require 'help/include_libraries'

# CloudFormation template for Atraveo. 2-Tiered web-application with load-balancing.
cf = CfMain.new("Reference Architecture Web-Hosting")

####### input parameters
hosted_zone_id = "ZSSFB90C439AA"
hosted_zone_name = "dezidr.com"

ami_id = "ami-c6699baf"

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

#security groups
elb_sec_group = CfEc2SecurityGroup.new("ElbSecurityGroup", "Security Group for ELB")
elb_sec_group.add_ingress_rule(CfEc2SecurityGroupIngress.new("tcp", 80, 80, "0.0.0.0/0"))
elb_sec_group.add_ingress_rule(CfEc2SecurityGroupIngress.new("tcp", 443, 443, "0.0.0.0/0"))
cf.add_resource(elb_sec_group)

app_sec_group = CfEc2SecurityGroup.new("AppSecurityGroup", "Security Group for web and app")
app_sec_group.add_ingress_rule(CfEc2SecurityGroupIngress.new("tcp", 22, 22, "0.0.0.0/0"))
ir1 = CfEc2SecurityGroupIngress.new("tcp", param_app_port.generate_ref(), param_app_port.generate_ref(), nil, elb_sec_group)
ir1.set_use_sg_id(false)
app_sec_group.add_ingress_rule(ir1)
cf.add_resource(app_sec_group)

rds_sec_group = CfRdsSecurityGroup.new("RdsSecurityGroup","Security Group for RDS")
ir = CfRdsSecurityGroupIngress.new(nil,app_sec_group)
ir.set_use_sg_id(false)
rds_sec_group.add_rule(ir)
cf.add_resource(rds_sec_group)

#elb
#health_check_string = "HTTP:#{param_app_port.generate_ref()}/index.html"
health_check_string = "HTTP:80/index.html"
elb = CfElb.new("MyLoadBalancer", {    
  :health_check => CfHealthCheck.new("3","60", health_check_string,"10","2"),
  :listeners => [CfListener.new(param_app_port.generate_ref(),"http","80","http")],
  #:security_groups => [elb_sec_group],
  #:instances => [instance_a, instance_b],
  :availability_zones => CfHelper.availability_zones()
  }
)
cf.add_resource(elb)

#route53
cname = CfRoute53RecordSet.new("CnameRecord", "cname.#{hosted_zone_name}", "CNAME", {:ttl => 1, :resource_records => ["www1.test.com"], :hosted_zone_id => hosted_zone_id})
cf.add_resource(cname)
elb_alias = CfRoute53RecordSet.new("ElbAliasRecord","elb.#{hosted_zone_name}","A", {:alias_target => CfElbAliasTarget.new(elb), :hosted_zone_id => hosted_zone_id})
cf.add_resource(elb_alias)

#rds
options = {:multi_az => true, :security_groups => [rds_sec_group]}
rds_instance = CfRdsInstance.new("MyDatabase",5,"MySql","db.t1.micro",param_db_user.generate_ref(), param_db_pw.generate_ref, options)
cf.add_resource(rds_instance)

#auto-scaling group
launch_config = CfAsLaunchConfig.new("AppServerLaunchConfig", ami_id, "m1.micro", {:security_groups => [app_sec_group] })#, :user_data => rds_instance.retrieve_attribute("Endpoint.Address")}) 
availability_zones = [CfHelper.az_in_region("a"), CfHelper.az_in_region("b")]
as_group = CfAsGroup.new("AppServerFleet",availability_zones, launch_config, [elb], 4 ,2 ,options)

#cloudfront
origin = CfCustomOriginConfig.new("http-only",:http_port => 80)
origin_config = CfOrigin.new(elb.retrieve_attribute("DNSName") ,"CF001", origin)
default_cache_behavior = CfDefaultCacheBehavior.new(origin_config.id,CfForwardedValues.new(true),"allow-all",{:min_ttl => 0})
logging = CfLogging.new("s3","MyDistribution")
distribution_details = CfDistributionConfig.new([origin_config],default_cache_behavior,true, {:logging => logging, :aliases => ["elb.dezidr.com"]})
cloudfront_distribution = CfCloudfrontDistribution.new("MyDistribution",distribution_details)
cf.add_resource(cloudfront_distribution)

####### output parameters
elb_output = CfOutput.new("ElbEndpoint","Endpoint of the ELB",elb.retrieve_attribute("DNSName"))
cf.add_output(elb_output)
cloudfront_domain = CfOutput.new("CloudfrontDomain", "Endpoint of the CloudFront distribution", cloudfront_distribution.retrieve_attribute("DomainName"))
cf.add_output(cloudfront_domain)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
validator.apply({"AppServerAmi" => "ami-e96bdf80", "AppServerKey" => "majung", "AppPort" => "80",  "MasterUserName" => "iamauser", "MasterPassword" => "abcd1234"})

#puts "the reference for the VPC : #{vpc.generate_ref}"