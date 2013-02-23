#!/usr/bin/ruby

require 'cf_factory'

cf = CfFactory::CfMain.new("DynamoTableStack")

parameter_hash = CfFactory::CfParameter.new("HashKeyName", "Name of the hash key", "String", {"Default" => "hashkey"})
cf.add_parameter(parameter_hash)

dynamo_table = CfFactory::CfDynamoTable.new("DynamoTable",
                                            10, 10,
                                            parameter_hash.generate_ref, "S")
                                            
cf.add_resource(dynamo_table)

output_dynamo_table_name = CfFactory::CfOutput.new("DynamoTableName", "The name of the Dynamo table", dynamo_table.generate_ref())
cf.add_output(output_dynamo_table_name)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = CfFactory::TemplateValidation.new(cf_json, config_options)
validator.validate()
