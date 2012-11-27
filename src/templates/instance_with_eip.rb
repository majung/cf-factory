require 'help/include_libraries'

cf = CfMain.new("Playground")
##########################

mapping = CfMapping.new("Region2AmiMapping","AMI", {
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
instance = CfEc2Instance.new("MyInstance", ami, "t1.micro")
cf.add_resource(instance)
eip = CfEip.new("MyEip",instance)
cf.add_resource(eip)
instance_ip_assoc = CfEipAssociation.new("MyEipAllocation", eip, instance, nil)
cf.add_resource(instance_ip_assoc)

eip_output = CfOutput.new("Eip", "Id of the EIP", eip.generate_ref())
cf.add_output(eip_output)
#eip_ip_output = CfOutput.new("Eip", "Id of the EIP", eip.retrieve_attribute("AllocationId")) only works for VPC
#cf.add_output(eip_ip_output)
assoc_output = CfOutput.new("Assoc", "Id of the Assoc", instance_ip_assoc.generate_ref())
cf.add_output(assoc_output)
##########################
cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
validator.apply()

