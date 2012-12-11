require 'help/include_libraries'

# CloudFormation template for Atraveo. 2-Tiered web-application with load-balancing.
cf = CfMain.new("Reference Architecture Web-Hosting")

####### input parameters
hosted_zone_id = "ZSSFB90C439AA"
hosted_zone_name = "dezidr.com"

#ami_id = "ami-c6699baf"
#ami_id = "ami-e96bdf80" #eu-west NAT instance
ami_id = "ami-e96bdf80" #us-east web-server returning something

param_hosted_zone = CfParameter.new("HostedZoneId", "Needs an existing hosted zone in Route53 to be configured", "String", {"Default" => hosted_zone_id})
cf.add_parameter(param_hosted_zone)
param_app_server_ami = CfParameter.new("AppServerAmi", "AMI of App-Server", "String", {"Default" => ami_id})
cf.add_parameter(param_app_server_ami)
param_app_server_key = CfParameter.new("AppServerKey", "Key used to start  App-Server", "String")
cf.add_parameter(param_app_server_key)
param_app_port = CfParameter.new("AppPort", "Port of the Web/App-Servers", "Number", {"Default" => "8080"})
cf.add_parameter(param_app_port)
param_db_user = CfParameter.new("MasterUserName", "Name of the master user name of the DB", "String", {"Default" => "masteruser"})
cf.add_parameter(param_db_user)
param_db_pw = CfParameter.new("MasterPassword", "Password of the master user of the DB", "String")
cf.add_parameter(param_db_pw)

zone = "us-east"

####### mappings

####### resources

#ebs test
ebs = CfEbsVolume.create_normal("MyEbs",CfHelper.az_in_region(az_id = "b"),  5)
cf.add_resource(ebs)

s3_bucket = CfS3Bucket.new("MyS3Bucket")
cf.add_resource(s3_bucket)
s3_log_bucket = CfS3Bucket.new("MyS3LogBucket")
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
elb = CfElb.new("MyLoadBalancer", {    
  :health_check => CfHealthCheck.new("3","60", health_check_string,"10","2"),
  :listeners => [CfListener.new(param_app_port.generate_ref(),"http","80","http")],
  #:security_groups => [elb_sec_group], #only for VPC based ELBs
  :availability_zones => CfHelper.availability_zones()
  }
)
cf.add_resource(elb)

app_sec_group = CfEc2SecurityGroup.new("AppSecurityGroup", "Security Group for web and app")
app_sec_group.add_ingress_rule(CfEc2SecurityGroupIngress.new("tcp", 22, 22, "0.0.0.0/0"))
ir1 = CfEc2SecurityGroupIngress.new("tcp", param_app_port.generate_ref(), param_app_port.generate_ref(), "0.0.0.0/0")
app_sec_group.add_ingress_rule(ir1)
cf.add_resource(app_sec_group)

rds_sec_group = CfRdsSecurityGroup.new("RdsSecurityGroup","Security Group for RDS")
ir = CfRdsSecurityGroupIngress.new(nil,app_sec_group)
ir.set_use_sg_id(false)
rds_sec_group.add_rule(ir)
cf.add_resource(rds_sec_group)

#rds
rds_endpoint= "rdsendpoint"
#options = {:multi_az => true, :security_groups => [rds_sec_group]}
#rds_instance = CfRdsInstance.new("MyDatabase",5,"MySql","db.t1.micro",param_db_user.generate_ref(), param_db_pw.generate_ref, options)
#cf.add_resource(rds_instance)
#rds_endpoint = rds_instance.retrieve_attribute("Endpoint.Address") 

#iam-role to be able to read meta-data
statement = CfIamStatement.new("Allow","cloudformation:DescribeStackResource","*")
role_policy = CfIamPolicy.new("MyRolePolicy", CfPolicyDocument.new([statement]))
iam_role = CfIamRole.new("ReadMetaData","/",{:policies => [role_policy]})
cf.add_resource(iam_role)



#auto-scaling group
launch_config = CfAsLaunchConfig.new("AppServerLaunchConfig", ami_id, "t1.micro", {:security_groups => [app_sec_group], :user_data => rds_endpoint})
cf.add_resource(launch_config)   
availability_zones = CfHelper.az_array_in_region(["b","c"])
as_group = CfAsGroup.new("AppServerFleet",availability_zones, launch_config, [elb], 4 ,2 ,{:desired_capacity => 2})
cf.add_resource(as_group)

#cloudfront
# distribution with multiple origins, one for S3, one for the ELB   
#define origins
elb_origin = CfOrigin.create_elb_origin(elb)
s3_origin = CfOrigin.create_s3_origin(s3_bucket) 
origins = [elb_origin, s3_origin]
#define cache behaviors for origins
default_cache_behavior = CfDefaultCacheBehavior.create_basic(elb_origin.id)
cache_behaviors = [
  CfCacheBehavior.create_basic(s3_origin.id, "/static/*", :min_ttl => 24*60*60),
  CfCacheBehavior.create_basic(s3_origin.id, "*.jpg", :min_ttl => 24*60*60)  
]
#tie everything together
cname_endpoint = "cached-elb-#{(Random.new.rand*100000).to_i}.dezidr.com"
logging = CfLogging.new(s3_log_bucket,"log-") #activate logging
cf_distribution = CfCloudfrontDistribution.create_multi_origin_distribution("MyDistribution", origins,
  default_cache_behavior, cache_behaviors, {:logging => logging, :aliases => [cname_endpoint]})
cf.add_resource(cf_distribution)

#route53
cloudfront_dns = cf_distribution.retrieve_attribute("DomainName")
cname = CfRoute53RecordSet.new("CnameRecord", "#{cname_endpoint}", "CNAME", {:ttl => 1, :resource_records => [cloudfront_dns], :hosted_zone_id => hosted_zone_id})
cf.add_resource(cname)
elb_alias = CfRoute53RecordSet.new("ElbAliasRecord","elb-#{(Random.new.rand*100000).to_i}.#{hosted_zone_name}","A", {:alias_target => CfElbAliasTarget.new(elb), :hosted_zone_id => hosted_zone_id})
cf.add_resource(elb_alias)

####### output parameters
elb_output = CfOutput.new("ElbEndpoint","Endpoint of the ELB",elb.retrieve_attribute("DNSName"))
cf.add_output(elb_output)
cloudfront_domain = CfOutput.new("CloudfrontDomain", "Endpoint of the CloudFront distribution", cf_distribution.retrieve_attribute("DomainName"))
cf.add_output(cloudfront_domain)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
config_options["cloud_formation_endpoint"] = "cloudformation.us-east-1.amazonaws.com"
puts config_options.inspect
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
validator.apply({"AppServerAmi" => ami_id, "AppServerKey" => "majung", "AppPort" => "80",  "MasterUserName" => "iamauser", "MasterPassword" => "abcd1234"})

#puts "the reference for the VPC : #{vpc.generate_ref}"