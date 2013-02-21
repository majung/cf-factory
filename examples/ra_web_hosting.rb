#!/usr/bin/ruby

require 'cf_factory'

# CloudFormation template for Atraveo. 2-Tiered web-application with load-balancing.
cf = CfFactory::CfMain.new("Reference Architecture Web-Hosting")

####### input parameters
hosted_zone_id = "ZSSFB90C439AA"
hosted_zone_name = "dezidr.com"

#ami_id = "ami-c6699baf"
#ami_id = "ami-e96bdf80" #eu-west NAT instance
ami_id = "ami-e96bdf80" #us-east web-server returning something

param_hosted_zone = CfFactory::CfParameter.new("HostedZoneId", "Needs an existing hosted zone in Route53 to be configured", "String", {"Default" => hosted_zone_id})
cf.add_parameter(param_hosted_zone)
param_app_server_ami = CfFactory::CfParameter.new("AppServerAmi", "AMI of App-Server", "String", {"Default" => ami_id})
cf.add_parameter(param_app_server_ami)
param_app_server_key = CfFactory::CfParameter.new("AppServerKey", "Key used to start  App-Server", "String")
cf.add_parameter(param_app_server_key)
param_app_port = CfFactory::CfParameter.new("AppPort", "Port of the Web/App-Servers", "Number", {"Default" => "8080"})
cf.add_parameter(param_app_port)
param_db_user = CfFactory::CfParameter.new("MasterUserName", "Name of the master user name of the DB", "String", {"Default" => "masteruser"})
cf.add_parameter(param_db_user)
param_db_pw = CfFactory::CfParameter.new("MasterPassword", "Password of the master user of the DB", "String")
cf.add_parameter(param_db_pw)

zone = "us-east"

####### mappings

####### resources

#ebs test
ebs = CfFactory::CfEbsVolume.create_normal("MyEbs",CfFactory::CfHelper.az_in_region(az_id = "b"),  5)
cf.add_resource(ebs)

s3_bucket = CfFactory::CfS3Bucket.new("MyS3Bucket")
cf.add_resource(s3_bucket)
s3_log_bucket = CfFactory::CfS3Bucket.new("MyS3LogBucket")
s3_log_bucket.set_deletion_policy("Delete")
cf.add_resource(s3_log_bucket)

#security groups
# ELB security groups apparently only available for VPC
#elb_sec_group = CfEc2SecurityGroup.new("ElbSecurityGroup", "Security Group for ELB")
#elb_sec_group.add_ingress_rule(CfEc2SecurityGroupIngress.new("tcp", 80, 80, "0.0.0.0/0"))
#elb_sec_group.add_ingress_rule(CfEc2SecurityGroupIngress.new("tcp", 443, 443, "0.0.0.0/0"))
#cf.add_resource(elb_sec_group)

#elb
#health_check_string = "HTTP:#{param_app_port.generate_ref()}/index.html"
health_check_string = "HTTP:80/index.html"
elb = CfFactory::CfElb.new("MyLoadBalancer", {    
  :health_check => CfFactory::CfHealthCheck.new("3","60", health_check_string,"10","2"),
  :listeners => [CfFactory::CfListener.new(param_app_port.generate_ref(),"http","80","http")],
  #:security_groups => [elb_sec_group], #only for VPC based ELBs
  :availability_zones => CfFactory::CfHelper.availability_zones()
  }
)
cf.add_resource(elb)

app_sec_group = CfFactory::CfEc2SecurityGroup.new("AppSecurityGroup", "Security Group for web and app")
app_sec_group.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("tcp", 22, 22, "0.0.0.0/0"))
ir1 = CfFactory::CfEc2SecurityGroupIngress.new("tcp", param_app_port.generate_ref(), param_app_port.generate_ref(), "0.0.0.0/0")
app_sec_group.add_ingress_rule(ir1)
cf.add_resource(app_sec_group)

rds_sec_group = CfFactory::CfRdsSecurityGroup.new("RdsSecurityGroup","Security Group for RDS")
ir = CfFactory::CfRdsSecurityGroupIngress.new(nil,app_sec_group)
ir.set_use_sg_id(false)
rds_sec_group.add_rule(ir)
cf.add_resource(rds_sec_group)

#rds
rds_endpoint= "rdsendpoint"
options = {:multi_az => true, :security_groups => [rds_sec_group]}
rds_instance = CfFactory::CfRdsInstance.new("MyDatabase",5,"MySql","db.t1.micro",param_db_user.generate_ref(), param_db_pw.generate_ref, options)
cf.add_resource(rds_instance)
rds_endpoint = rds_instance.retrieve_attribute("Endpoint.Address") 

#iam-role to be able to read meta-data
statement = CfFactory::CfIamStatement.new("Allow","cloudformation:DescribeStackResource","*")
role_policy = CfFactory::CfIamPolicy.new("MyRolePolicy", CfFactory::CfPolicyDocument.new([statement]))
iam_role = CfFactory::CfIamRole.new("ReadMetaData","/",{:policies => [role_policy]})
cf.add_resource(iam_role)

#auto-scaling group
launch_config = CfFactory::CfAsLaunchConfig.new("AppServerLaunchConfig", ami_id, "t1.micro", {:security_groups => [app_sec_group], :user_data => rds_endpoint})
cf.add_resource(launch_config)   
availability_zones = CfFactory::CfHelper.az_array_in_region(["b","c"])
as_group = CfFactory::CfAsGroup.new("AppServerFleet",availability_zones, launch_config, [elb], 4 ,2 ,{:desired_capacity => 2})
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

#cloudfront
# distribution with multiple origins, one for S3, one for the ELB   
#define origins
elb_origin = CfFactory::CfOrigin.create_elb_origin(elb)
s3_origin = CfFactory::CfOrigin.create_s3_origin(s3_bucket) 
origins = [elb_origin, s3_origin]
#define cache behaviors for origins
default_cache_behavior = CfFactory::CfDefaultCacheBehavior.create_basic(elb_origin.id)
cache_behaviors = [
  CfFactory::CfCacheBehavior.create_basic(s3_origin.id, "/static/*", :min_ttl => 24*60*60),
  CfFactory::CfCacheBehavior.create_basic(s3_origin.id, "*.jpg", :min_ttl => 24*60*60)  
]
#tie everything together
cname_endpoint = "cached-elb-#{(Random.new.rand*100000).to_i}.dezidr.com"
logging = CfFactory::CfLogging.new(s3_log_bucket,"log-") #activate logging
cf_distribution = CfFactory::CfCloudfrontDistribution.create_multi_origin_distribution("MyDistribution", origins,
  default_cache_behavior, cache_behaviors, {:logging => logging, :aliases => [cname_endpoint]})
cf.add_resource(cf_distribution)

#route53
cloudfront_dns = cf_distribution.retrieve_attribute("DomainName")
cname = CfFactory::CfRoute53RecordSet.new("CnameRecord", "#{cname_endpoint}", "CNAME", {:ttl => 1, :resource_records => [cloudfront_dns], :hosted_zone_id => hosted_zone_id})
cf.add_resource(cname)
elb_alias = CfFactory::CfRoute53RecordSet.new("ElbAliasRecord","elb-#{(Random.new.rand*100000).to_i}.#{hosted_zone_name}","A", {:alias_target => CfFactory::CfElbAliasTarget.new(elb), :hosted_zone_id => hosted_zone_id})
cf.add_resource(elb_alias)

####### output parameters
elb_output = CfFactory::CfOutput.new("ElbEndpoint","Endpoint of the ELB",elb.retrieve_attribute("DNSName"))
cf.add_output(elb_output)
cloudfront_domain = CfFactory::CfOutput.new("CloudfrontDomain", "Endpoint of the CloudFront distribution", cf_distribution.retrieve_attribute("DomainName"))
cf.add_output(cloudfront_domain)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
config_options["cloud_formation_endpoint"] = "cloudformation.us-east-1.amazonaws.com"
puts config_options.inspect
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()
#validator.apply({"AppServerAmi" => ami_id, "AppServerKey" => "majung", "AppPort" => "80",  "MasterUserName" => "iamauser", "MasterPassword" => "abcd1234"})

#puts "the reference for the VPC : #{vpc.generate_ref}"
