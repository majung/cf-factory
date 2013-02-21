#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("Playground")
##########################
ami = "ami-1624987f"

input_keyname = CfFactory::CfParameter.new("KeyName","Name of key for SSH access","String",{"Default" => "majung"})
cf.add_parameter(input_keyname)
input_ami = CfFactory::CfParameter.new("AMI","ID of AMI for instance","String",{"Default" => ami})
cf.add_parameter(input_ami)  

statement = CfFactory::CfIamStatement.new("Allow","cloudformation:DescribeStackResource","*")
role_policy = CfFactory::CfIamPolicy.new("MyRolePolicy", CfFactory::CfPolicyDocument.new([statement]))
iam_user = CfFactory::CfIamUser.new("IamUser","/",{:policies => [role_policy]})
cf.add_resource(iam_user)
iam_access_key = CfFactory::CfIamAccessKey.new("IamAccessKey",iam_user.generate_ref,"Active")
cf.add_resource(iam_access_key)

script = CfFactory::CfInitScript.create_basic("MyInstance",iam_access_key.generate_ref,iam_access_key.retrieve_attribute("SecretAccessKey"))
#full_init_script = script.user_data()
full_init_script = CfFactory::CfHelper.join([
  "#!/bin/bash -v\\n",
  "yum update -y aws-cfn-bootstrap\\n",
  "/opt/aws/bin/cfn-init -s ", CfFactory::CfHelper.generate_ref("AWS::StackName"), 
  " -r ", "InstanceLaunchConfig ",
  " --access-key ", iam_access_key.generate_ref,
  " --secret-key ", iam_access_key.retrieve_attribute("SecretAccessKey")]
)

packages = CfFactory::CfCloudFormationPackages.new([CfFactory::CfCloudFormationPackage.new("yum","httpd","2.2.13")])
commands = CfFactory::CfCloudFormationCommands.new([
  CfFactory::CfCloudFormationCommand.new("command1","echo cloudinit"),
  CfFactory::CfCloudFormationCommand.new("command2","echo cloudinit > /var/log/my-cloudinit.txt")
  ])
config1 = CfFactory::CfCloudFormationConfig.new("config1", nil, commands, nil, packages)
config2 = CfFactory::CfCloudFormationConfig.new("config", nil, commands, nil, nil)

#auto-scaling group
launch_config = CfFactory::CfAsLaunchConfig.new("InstanceLaunchConfig", input_ami.generate_ref, "t1.micro", { :key_name => input_keyname.generate_ref(), :user_data => full_init_script})
meta_data = CfFactory::CfCloudFormationInit.new([config2])
launch_config.set_meta_data(meta_data) 
cf.add_resource(launch_config)
availability_zones = CfFactory::CfHelper.az_array_in_region(["b","c"])
as_group = CfFactory::CfAsGroup.new("AppServerFleet",availability_zones, launch_config, [], 4 ,2 ,{:desired_capacity => 2})
cf.add_resource(as_group)
as_up_scaling_policy = CfFactory::CfAsScalingPolicy.new("MyUpscalePolicy",as_group,"ChangeInCapacity","1",{:cooldown => 300})
cf.add_resource(as_up_scaling_policy)
as_down_scaling_policy = CfFactory::CfAsScalingPolicy.new("MyDownscalePolicy",as_group,"ChangeInCapacity","-1",{:cooldown => 300})
cf.add_resource(as_down_scaling_policy)
as_up_alarm = CfFactory::CfCloudWatchAlarm.new("MyUpAlarm",CfFactory::CfCloudWatchAlarm::GREATER_THAN_OR_EQUAL_TO_THRESHOLD, "3", "CPUUtilization","AWS/EC2",
  "60","Average","80", {:alarm_actions => [as_up_scaling_policy]})
as_down_alarm = CfFactory::CfCloudWatchAlarm.new("MyDownAlarm",CfFactory::CfCloudWatchAlarm::LESS_THAN_THRESHOLD, "3", "CPUUtilization","AWS/EC2",
  "60","Average","30", {:alarm_actions => [as_down_scaling_policy]}) 
cf.add_resource(as_up_alarm)
cf.add_resource(as_down_alarm)

stackname = CfFactory::CfOutput.new("StackName","Name of CloudFormation stack",CfFactory::CfHelper.generate_ref("AWS::StackName"))
cf.add_output(stackname)
access_key = CfFactory::CfOutput.new("AccessKey","Access key",iam_access_key.generate_ref)
cf.add_output(access_key)
secret_key = CfFactory::CfOutput.new("SecretKey","Secret key",iam_access_key.retrieve_attribute("SecretAccessKey"))
cf.add_output(secret_key)

output_command = CfFactory::CfOutput.new("FullCommand", "Full command to be executed", 
  CfFactory::CfHelper.join(["/opt/aws/bin/cfn-init -s ", CfFactory::CfHelper.generate_ref("AWS::StackName"), 
    " -r ", launch_config.get_name(),
    " --access-key ", iam_access_key.generate_ref,
    " --secret-key ", iam_access_key.retrieve_attribute("SecretAccessKey")]
    ))
cf.add_output(output_command)

tag = CfFactory::CfEc2Tag.new("CloudFormationTests","active")
cf.apply_tags_to_all_resources([tag])

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
config_options["cloud_formation_endpoint"] = "cloudformation.us-east-1.amazonaws.com"
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()

