require 'cf_factory/base/cf_base'

class CfVpc
  include CfBase
  
  def initialize(cidr, name = "MyVpc")
    @cidr = cidr
    @name = name
    @subnets = []
    @igws = []
    @route_tables = []
    @network_acls = []
  end
    
  def get_cf_type
    "AWS::EC2::VPC"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"CidrBlock" => @cidr}
  end  
  
  def add_subnet(subnet)
    subnet.set_vpc(self)
    @subnets << subnet
  end
  
  def add_route_table(route_table)
    route_table.set_vpc(self)
    @route_tables << route_table
  end
  
  def add_internet_gateway(igw)
    @igws << igw
  end
  
  def add_network_acl(network_acl)
    network_acl.set_vpc(self)
    @network_acls << network_acl
  end
  
  def generate
    super
    @igws.each() {|ig|
      @result += ig.generate
    }
    @route_tables.each() {|rt|
      @result += rt.generate
    }
    @network_acls.each() {|acl|
      @result += acl.generate
    }
    @subnets.each() {|sn|
      @result += sn.generate
    }
    #
    @result        
  end
  
end