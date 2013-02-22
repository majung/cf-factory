#!/usr/bin/ruby

require 'cf_factory'

# CloudFormation template for Atraveo. 2-Tiered web-application with load-balancing.
cf = CfFactory::CfMain.new("CloudFront with ELB as origin with dynamic content")
app_port = 8080
key_name = "default"
app_server_ami = "ami-c6699baf"
spot_price = "0.02"

####### input parameters
param_app_server_ami = CfFactory::CfParameter.new("AppServerAmi", "AMI of App-Server", "String")
cf.add_parameter(param_app_server_ami)
param_app_server_key = CfFactory::CfParameter.new("AppServerKey", "Key used to start  App-Server", "String")
cf.add_parameter(param_app_server_key)
param_app_port = CfFactory::CfParameter.new("AppPort", "Port of the Web/App-Servers", "Number", {"Default" => "8080"})
cf.add_parameter(param_app_port)

zone = "us-east"

####### mappings

####### resources

#VPC/subnets: all public to be able to be able to connect the instances by adding an EIP
#VPC, IGW, and route tables
vpc = CfFactory::CfVpc.new("10.10.0.0/16")
cf.add_vpc(vpc)
igw = CfFactory::CfInternetGateway.new("MyInternetGateway", vpc)
vpc.add_internet_gateway(igw)
public_route_table = CfFactory::CfRouteTable.new("InternetRouteTable")
igw_route = CfFactory::CfRoute.new("IgwRoute", "0.0.0.0/0", igw)
public_route_table.add_route(igw_route)
vpc.add_route_table(public_route_table)

# subnets
subnet_elb_a = CfFactory::CfSubnet.new("SubnetElbA", "10.10.1.0/24", "#{zone}-1c", public_route_table)
vpc.add_subnet(subnet_elb_a)
subnet_elb_b = CfFactory::CfSubnet.new("SubnetElbB", "10.10.2.0/24", "#{zone}-1b", public_route_table)
vpc.add_subnet(subnet_elb_b)
subnet_web_a = CfFactory::CfSubnet.new("SubnetWebA", "10.10.3.0/24", "#{zone}-1c", public_route_table)
vpc.add_subnet(subnet_web_a)
subnet_web_b = CfFactory::CfSubnet.new("SubnetWebB", "10.10.4.0/24", "#{zone}-1b", public_route_table)
vpc.add_subnet(subnet_web_b)

#security groups
elb_security_group_name = "ElbSecurityGroup"
elb_sec_group = CfFactory::CfEc2SecurityGroup.new(elb_security_group_name, "Group for ELB", vpc)
elb_sec_group.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("tcp", 80, 80, "0.0.0.0/0"))
elb_sec_group.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("tcp", 443, 443, "0.0.0.0/0"))
cf.add_resource(elb_sec_group)

app_security_group_name = "AppSecurityGroup"
app_sec_group = CfFactory::CfEc2SecurityGroup.new(app_security_group_name, "Group for web and app", vpc)
app_sec_group.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("tcp", 22, 22, "0.0.0.0/0"))
app_sec_group.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("tcp", param_app_port.generate_ref(), param_app_port.generate_ref(), nil, elb_sec_group))
cf.add_resource(app_sec_group)

#application servers (one in each region)
options = {}
instance_a = CfFactory::CfEc2Instance.new("InstanceA",param_app_server_ami.generate_ref, "t1.micro", {:subnet => subnet_web_a, :vpc_security_groups => [app_sec_group]})
instance_b = CfFactory::CfEc2Instance.new("InstanceB",param_app_server_ami.generate_ref, "t1.micro", {:subnet => subnet_web_b, :vpc_security_groups => [app_sec_group]})
cf.add_resource(instance_a)
cf.add_resource(instance_b)

#elb
#health_check_string = "HTTP:#{param_app_port.generate_ref()}/index.html"
health_check_string = "HTTP:80/index.html"
elb = CfFactory::CfElb.new("MyLoadBalancer", {
  :subnets => [subnet_elb_a, subnet_elb_b],  
  #:app_cookie_stickiness_policy => [CfAppCookieStickinessPolicy.new("cookiename","policybla")],    
  :health_check => CfFactory::CfHealthCheck.new("3","60", health_check_string,"10","2"),
  :listeners => [CfFactory::CfListener.new(param_app_port.generate_ref(),"http","80","http")],
  :security_groups => [elb_sec_group],
  :instances => [instance_a, instance_b]
  }
)
cf.add_resource(elb)

#cloudfront
origin = CfFactory::CfCustomOriginConfig.new("http-only",:http_port => 80)
origin_config = CfFactory::CfOrigin.new(elb.retrieve_attribute("DNSName") ,"CF001", origin)
default_cache_behavior = CfFactory::CfDefaultCacheBehavior.new(origin_config.id,CfFactory::CfForwardedValues.new(true),"allow-all",{:min_ttl => 0})
distribution_details = CfFactory::CfDistributionConfig.new([origin_config],default_cache_behavior,true)
cloudfront_distribution = CfFactory::CfCloudfrontDistribution.new("MyDistribution",distribution_details)
cf.add_resource(cloudfront_distribution)

####### output parameters
elb_output = CfFactory::CfOutput.new("ElbEndpoint","Endpoint of the ELB",elb.retrieve_attribute("DNSName"))
cf.add_output(elb_output)
cloudfront_domain = CfFactory::CfOutput.new("CloudfrontDomain", "Endpoint of the CloudFront distribution", cloudfront_distribution.retrieve_attribute("DomainName"))
cf.add_output(cloudfront_domain)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()
