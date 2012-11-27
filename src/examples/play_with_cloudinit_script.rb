require 'help/include_libraries'

cf = CfMain.new("Playground")
##########################

instance = CfEc2Instance.new("MyInstance","ami-12345","m1.small",{})
sources1 = CfCloudFormationSources.new([{"/etc/a.txt" => "http://bla/a.txt"}, {"/etc/b.txt" => "http://bla/b.txt"}])
command1 = CfCloudFormationCommand.new("command1","echo something > a.txt", :env => "MAGIC")
commands1 = CfCloudFormationCommands.new([command1])
config1 = CfCloudFormationConfig.new("config1", sources1, commands1, nil, nil)
sources2 = CfCloudFormationSources.new([{"/etc/c.txt" => "http://bla/c.txt"}, {"/etc/d.txt" => "http://bla/d.txt"}])
file21 = CfCloudFormationFile.new("/tmp/setup.mysql","content...","root","root","000644")
files2 = CfCloudFormationFiles.new([file21]) 
config2 = CfCloudFormationConfig.new("config2", sources2, nil, files2)  
meta_data = CfCloudFormationInit.new([config1, config2])
instance.set_meta_data(meta_data) 
cf.add_resource(instance)

##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
