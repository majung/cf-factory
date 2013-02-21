#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("Playground")
##########################

mapping = CfFactory::CfMapping.new("Region2AmiMapping","AMI", {
    "us-east-1" => "ami-c6699baf",
    "us-west-2" => "ami-52ff7262",
    "us-west-1" => "ami-3bcc9e7e",
    "eu-west-1" => "ami-c37474b7",#"ami-0b5b6c7f",
    "ap-southeast-1" => "ami-02eb9350",
    "ap-northeast-1" => "ami-14d86d15",
    "sa-east-1" => "ami-0439e619"
  })
cf.add_mapping(mapping)
ami = mapping.map_from_region()
  puts "AMI = #{ami}"
instance = CfFactory::CfEc2Instance.new("MyInstance", ami, "t1.micro", {:keyname => "majung-eu"})
cf.add_resource(instance)

packages = CfFactory::CfCloudFormationPackages.new([
  CfFactory::CfCloudFormationPackage.new("yum", "rubygems", []),
  CfFactory::CfCloudFormationPackage.new("yum", "rubygem-aws-sdk", []),
  CfFactory::CfCloudFormationPackage.new("rubygems", "cloudyscripts", ["2.14.60"])
])
config = CfFactory::CfCloudFormationConfig.new("GemInstallation", nil, nil, nil, packages)
cloud_init_config = CfFactory::CfCloudFormationInit.new([config])
instance.set_meta_data(cloud_init_config)

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()
#validator.apply()

