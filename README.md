cf_factory
==========

Cf_factory is a Ruby library to generate CloudFormation templates.

Build the local gem file with:
gem build cf_factory.gemspec

Install the gem locally with:
sudo gem install ./cf_factory-x.x.x.gemspec

**Example Code:**
    
    require 'cf_factory'


    cf = CfFactory::CfMain.new("Example template")
    ####### input parameters
    parameter = CfFactory::CfParameter.new("KeyName", "Name of the key", "String")
    cf.add_parameter(parameter)

    ####### mappings
    mapping = CfFactory::CfMapping.new("Default","AMI",{"us-east-1" => "ami-c6699baf", "us-west-2" => "ami-52ff7262"})
    cf.add_mapping(mapping)

    ####### resources
    vpc = CfFactory::CfVpc.new("10.10.0.0/16")
    cf.add_vpc(vpc)
    igw = CfFactory::CfInternetGateway.new("MyInternetGateway", vpc)
    vpc.add_internet_gateway(igw)
    route_table = CfFactory::CfRouteTable.new("MyRouteTable")
    vpc.add_route_table(route_table)
    route1 = CfFactory::CfRoute.new("MyRoute1", "88.44.22.11/32", igw)
    route2 = CfFactory::CfRoute.new("MyRoute2", "188.144.122.111/32", igw)
    route_table.add_route(route1)
    route_table.add_route(route2)

    network_acl = CfFactory::CfNetworkAcl.new("MyAcl1")
    vpc.add_network_acl(network_acl)
    network_acl_entry = CfFactory::CfNetworkAclEntry.new("Acl1", "110", "6", "ALLOW",  false, "0.0.0.0/0", 80, 80)
    network_acl.add_network_acl_entry(network_acl_entry)

    subnet1 = CfFactory::CfSubnet.new("WebTier1", "10.10.0.0/24", "us-east-1b", route_table, network_acl)
    vpc.add_subnet(subnet1)
    subnet2 = CfFactory::CfSubnet.new("AppTier1", "10.10.1.0/24", "us-east-1c", route_table, network_acl)
    vpc.add_subnet(subnet2)
    subnet3 = CfFactory::CfSubnet.new("DbTier1", "10.10.2.0/24", "us-east-1d", route_table, network_acl)
    vpc.add_subnet(subnet3)

    ####### output parameters
    output = CfFactory::CfOutput.new("VpcId", "Id of the VPC", vpc.generate_ref())
    cf.add_output(output)

    ####### validate and instantiate stack
    cf_json = cf.generate
    puts cf_json

    validator = CfFactory::TemplateValidation.new(cf_json, 
						{access_key_id: "ACCESSK_KEY_HERE",
                                                 secret_key_id: "SECRET_KEY_HERE"})
    validator.validate()


More examples can be found in the src/examples folder.
