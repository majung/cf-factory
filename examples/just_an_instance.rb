#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("JustAnInstance")
##########################

mapping = CfFactory::CfMapping.new("Region2AmiMapping","AMI", {
    "us-east-1" => "ami-c6699baf",
    "us-west-2" => "ami-52ff7262",
    "us-west-1" => "ami-3bcc9e7e",
    "eu-west-1" => "ami-0b5b6c7f",
    "ap-southeast-1" => "ami-02eb9350",
    "ap-northeast-1" => "ami-14d86d15",
    "sa-east-1" => "ami-0439e619"
  })
cf.add_mapping(mapping)
ami = mapping.map_from_region()
  puts "AMI = #{ami}"
instance = CfFactory::CfEc2Instance.new("MyInstance", ami, "t1.micro")
cf.add_resource(instance)

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()


