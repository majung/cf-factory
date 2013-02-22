#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("Playground")
##########################
ami = "ami-6d555119"

az = CfFactory::CfHelper.az_in_region("a")
instance = CfFactory::CfEc2Instance.new("MyInstance", ami, "t1.micro", {:availability_zone => az })
cf.add_resource(instance)

region_output = CfFactory::CfOutput.new("Region", "Region the stack was started", CfFactory::CfHelper.ref_current_region())
cf.add_output(region_output)
target_zone_output = CfFactory::CfOutput.new("TargetZone", "AZ where instance to be started", az)
cf.add_output(target_zone_output)
actual_zone_output = CfFactory::CfOutput.new("ActualInstanceZone", "AZ of started instance", instance.retrieve_attribute("AvailabilityZone"))
cf.add_output(actual_zone_output)

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()


