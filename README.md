cf-factory
==========

Cf-factory is a Ruby library to generate CloudFormation templates.

Disclaimer: This is a personal project. No relation whatsoever exists between this project and my employer.

**Example Code:
    
    require 'help/include_libraries'

    ####### input parameters
    parameter = CfParameter.new("KeyName", "Name of the key")
    cf.add_parameter(parameter)
    
    ####### mappings
    mapping = CfMapping.new("Default","AMI",{"us-east-1" => "ami-c6699baf", "us-west-2" => "ami-52ff7262"})
    cf.add_mapping(mapping)
    
    ####### resources
    vpc = CfVpc.new("10.10.0.0/16")
    cf.add_vpc(vpc)
    igw = CfInternetGateway.new("MyInternetGateway", vpc)
    vpc.add_internet_gateway(igw)
    route_table = CfRouteTable.new("MyRouteTable")
    vpc.add_route_table(route_table)
    route1 = CfRoute.new("MyRoute1", "88.44.22.11/32", igw)
    route2 = CfRoute.new("MyRoute2", "188.144.122.111/32", igw)
    route_table.add_route(route1)
    route_table.add_route(route2)
    
    network_acl = CfNetworkAcl.new("MyAcl1")
    vpc.add_network_acl(network_acl)
    network_acl_entry = CfNetworkAclEntry.new("Acl1", "110", "6", "ALLOW",  false, "0.0.0.0/0", 80, 80)
    network_acl.add_network_acl_entry(network_acl_entry)
    
    subnet1 = CfSubnet.new("WebTier1", "10.10.0.0/24", "eu-west-1a", route_table, network_acl)
    vpc.add_subnet(subnet1)
    subnet2 = CfSubnet.new("AppTier1", "10.10.1.0/24", "eu-west-1a", route_table, network_acl)
    vpc.add_subnet(subnet2)
    subnet3 = CfSubnet.new("DbTier1", "10.10.2.0/24", "eu-west-1a", route_table, network_acl)
    vpc.add_subnet(subnet2)
    
    ####### output parameters
    output = CfOutput.new("VPC_ID", "Id of the VPC", vpc.generate_ref())
    cf.add_output(output)
    
    ####### validate and instantiate stack
    puts cf.generate
    config_options = YAML.load_file("aws_config.yml")
    validator = TemplateValidation.new(cf_json, config_options)
    validator.validate({"KeyName" => 'my-key'})

