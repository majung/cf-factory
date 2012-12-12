require 'help/include_libraries'

cf = CfMain.new("Playground")
##########################
ami = "ami-1624987f"

input_keyname = CfParameter.new("KeyName","Name of key for SSH access","String",{"Default" => "majung"})
cf.add_parameter(input_keyname)
input_ami = CfParameter.new("AMI","ID of AMI for instance","String",{"Default" => ami})
cf.add_parameter(input_ami)  

statement = CfIamStatement.new("Allow","cloudformation:DescribeStackResource","*")
role_policy = CfIamPolicy.new("MyRolePolicy", CfPolicyDocument.new([statement]))
iam_user = CfIamUser.new("IamUser","/",{:policies => [role_policy]})
cf.add_resource(iam_user)
iam_access_key = CfIamAccessKey.new("IamAccessKey",iam_user.generate_ref,"Active")
cf.add_resource(iam_access_key)

script = CfInitScript.create_basic("MyInstance",iam_access_key.generate_ref,iam_access_key.retrieve_attribute("SecretAccessKey"))
#full_init_script = script.user_data()
full_init_script = CfHelper.join([
  "#!/bin/bash -v\\n",
  "yum update -y aws-cfn-bootstrap\\n",
  "/opt/aws/bin/cfn-init -s ", CfHelper.generate_ref("AWS::StackName"), 
  " -r ", "MyInstance ",
  " --access-key ", iam_access_key.generate_ref,
  " --secret-key ", iam_access_key.retrieve_attribute("SecretAccessKey")]
)

instance = CfEc2Instance.new("MyInstance",input_ami.generate_ref,"m1.small", 
  {:keyname => input_keyname.generate_ref(),
   :user_data => full_init_script
  }
)
packages = CfCloudFormationPackages.new([CfCloudFormationPackage.new("yum","httpd","2.2.13")])
commands = CfCloudFormationCommands.new([
  CfCloudFormationCommand.new("command1","echo cloudinit"),
  CfCloudFormationCommand.new("command2","echo cloudinit > /var/log/my-cloudinit.txt")
  ])
config1 = CfCloudFormationConfig.new("config1", nil, commands, nil, packages)
config2 = CfCloudFormationConfig.new("config", nil, commands, nil, nil)

meta_data = CfCloudFormationInit.new([config2])
instance.set_meta_data(meta_data) 
cf.add_resource(instance)

stackname = CfOutput.new("StackName","Name of CloudFormation stack",CfHelper.generate_ref("AWS::StackName"))
cf.add_output(stackname)
instance_ip = CfOutput.new("InstanceIp","DNS Name of instance created",instance.retrieve_attribute("PublicDnsName"))
cf.add_output(instance_ip)
access_key = CfOutput.new("AccessKey","Access key",iam_access_key.generate_ref)
cf.add_output(access_key)
secret_key = CfOutput.new("SecretKey","Secret key",iam_access_key.retrieve_attribute("SecretAccessKey"))
cf.add_output(secret_key)

output_command = CfOutput.new("FullCommand", "Full command to be executed", 
  CfHelper.join(["/opt/aws/bin/cfn-init -s ", CfHelper.generate_ref("AWS::StackName"), 
    " -r ", instance.get_name(),
    " --access-key ", iam_access_key.generate_ref,
    " --secret-key ", iam_access_key.retrieve_attribute("SecretAccessKey")]
    ))
cf.add_output(output_command)

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
config_options["cloud_formation_endpoint"] = "cloudformation.us-east-1.amazonaws.com"
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
validator.apply
