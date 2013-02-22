#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("NAT Mutual Monitoring")
####### input parameters
param_keyname = CfFactory::CfParameter.new("KeyName", "Name of the key", "String", {"Default" => "majung"})
cf.add_parameter(param_keyname)
param_vpc_cidr  = CfFactory::CfParameter.new("VpcCidr", "CIDR of the VPC", "String", {"Default" => "10.0.0.0/16"})
cf.add_parameter(param_vpc_cidr)
param_nat_type = CfFactory::CfParameter.new("NatInstanceType", "Type/size of the NAT instances", "String", {"Default" => "m1.small", "AllowedValues" => CfFactory::CfEc2Instance::SUPPORTED_TYPES})
cf.add_parameter(param_nat_type)

####### mappings
mapping = CfFactory::CfMapping.new("NatMapping","AMI", {"eu-west-1" => "ami-0b5b6c7f", "us-east-1" => "ami-f619c29f"})
cf.add_mapping(mapping)

####### resources
#vpc
base_vpc = CfFactory::BaseVpc.new("BaseVpc","192.168.0.0/16",2,2,["eu-west-1a","eu-west-1b"],256)
base_vpc.add_to_template(cf)
vpc = base_vpc.vpc
public_sn1, public_sn2, private_sn1, private_sn2 = base_vpc.subnets  

#iam
commands = ["ec2:DescribeInstances","ec2:DescribeRouteTables", "ec2:ReplaceRoute","ec2:StartInstances","ec2:StopInstances"]
statement = CfFactory::CfIamStatement.new("Allow",commands,"*")
role_policy = CfFactory::CfIamPolicy.new("MyRolePolicy", CfFactory::CfPolicyDocument.new([statement]))
nat_role = CfFactory::CfIamRole.new("NatRole", "/", {:policies => [role_policy]} )
cf.add_resource(nat_role)

#nats
script = CfFactory::CfHelper.join([
  "#!/bin/bash -v\\n",
  "yum update -y aws*\\n"
  ]
)
nat1 = CfFactory::CfEc2Instance.new("Nat1",mapping.generate_ref("AWS::Region"),param_nat_type.generate_ref, {:keyname => param_keyname.generate_ref(), :subnet => private_sn1, :user_data => script})
cf.add_resource(nat1)
eip1 = CfFactory::CfEip.new("Eip1",nat1,true)
cf.add_resource(eip1)
nat2 = CfFactory::CfEc2Instance.new("Nat2",mapping.generate_ref("AWS::Region"),param_nat_type.generate_ref, {:keyname => param_keyname.generate_ref(), :subnet => private_sn2, :user_data => script})
cf.add_resource(nat2)
eip2 = CfFactory::CfEip.new("Eip2",nat2,true)
cf.add_resource(eip2)
nat_sg = CfFactory::CfEc2SecurityGroup.new("NatSecurityGroup","Rules for allowing access to HA Nodes",vpc)
cf.add_resource(nat_sg)
nat_sg.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("tcp",22,22,"0.0.0.0/0",nil))
nat_sg.add_ingress_rule(CfFactory::CfEc2SecurityGroupIngress.new("-1",0,0,param_vpc_cidr.generate_ref(),nil))
nat_sg.add_egress_rule(CfFactory::CfEc2SecurityGroupEgress.new("-1",0,0,"0.0.0.0/0",nil))

####### output parameters
out_vpc = CfFactory::CfOutput.new("BaseVpc", "Id of the VPC", vpc.generate_ref())
cf.add_output(out_vpc)
out_nat1 = CfFactory::CfOutput.new("OutNat1","EIP of NAT1",eip1.generate_ref())
cf.add_output(out_nat1)
out_nat2 = CfFactory::CfOutput.new("OutNat2","EIP of NAT2",eip2.generate_ref())
cf.add_output(out_nat2)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
#config_options["cloud_formation_endpoint"] = "cloudformation.us-east-1.amazonaws.com"

validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()

#puts "the reference for the VPC : #{vpc.generate_ref}"
