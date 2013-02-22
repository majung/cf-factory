#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("IngestReferenceArchitecture")

keypair = CfFactory::CfParameter.new("KeyName", "Name of the key",
                                     "String", {"Default" => ""})
cf.add_parameter(keypair)

capture_version = CfFactory::CfEbApplicationVersion.new("Capture Version 1", "Capture Version 1", "capture.zip", "1.0")

capture_option = CfFactory::CfEbOptionSetting.new("aws:autoscaling:launchconfiguration", "EC2KeyName", keypair.generate_ref())

capture_template = CfFactory::CfEbConfigurationTemplate.new("Capture Template", "Capture Template", [capture_option], :s64ruby193)
capture_application = CfFactory::CfEbApplication.new("Capture","Twitter Capture Service",
                                                     [capture_version], [capture_template])

cf_json = cf.generate
puts cf_json
 
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()
