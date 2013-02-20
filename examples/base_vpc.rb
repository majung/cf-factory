#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("Bla bla bla")
####### input parameters
parameter = CfFactory::CfParameter.new("KeyName", "Name of the key", "String", {"Default" => "majung"})
cf.add_parameter(parameter)
parameter2 = CfFactory::CfParameter.new("SecurityGroup", "Name of the security group", "String", {"Default" => "Blubber"})
cf.add_parameter(parameter2)

####### mappings
mapping = CfFactory::CfMapping.new("Default","AMI",{"us-east-1" => "ami-c6699baf", "us-west-2" => "ami-52ff7262"})
cf.add_mapping(mapping)

####### resources
#vpc
base_vpc = CfFactory::BaseVpc.new("BaseVpc","192.168.0.0/16",2,4,["eu-west-1a","eu-west-1b"],256)
base_vpc.add_to_template(cf)
vpc = base_vpc.vpc

network_acl = CfFactory::CfNetworkAcl.new("MyAcl1")
vpc.add_network_acl(network_acl)
network_acl_entry = CfFactory::CfNetworkAclEntry.new("Acl1", "110", "6", "ALLOW",  false, "0.0.0.0/0", 80, 80)
network_acl.add_network_acl_entry(network_acl_entry)

####### output parameters
output = CfFactory::CfOutput.new("BaseVpc", "Id of the VPC", vpc.generate_ref())
cf.add_output(output)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
config_options["cloud_formation_endpoint"] = "cloudformation.us-east-1.amazonaws.com"
puts config_options.inspect
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()

#puts "the reference for the VPC : #{vpc.generate_ref}"
