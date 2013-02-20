#!/usr/bin/ruby

require 'cf_factory'

cf = CfMain.new("Playground")
##########################

mapping = CfMapping.new("Region2AmiMapping","AMI", {
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
instance = CfEc2Instance.new("MyInstance", ami, "t1.micro", {:keyname => "majung-eu"})
cf.add_resource(instance)

packages = CfCloudFormationPackages.new([
  CfCloudFormationPackage.new("yum", "rubygems", []),
  CfCloudFormationPackage.new("yum", "rubygem-aws-sdk", []),
  CfCloudFormationPackage.new("rubygems", "cloudyscripts", ["2.14.60"])
])
config = CfCloudFormationConfig.new("GemInstallation", nil, nil, nil, packages)
cloud_init_config = CfCloudFormationInit.new([config])
instance.set_meta_data(cloud_init_config)

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
#validator.apply()

