require 'cf_factory/base/cf_base'
require 'cf_factory/vpc/cf_route_table_association'
require 'cf_factory/vpc/cf_network_acl_association'

class CfSubnet
  include CfBase
    
  def initialize(name, cidr_block, availability_zone, route_table = nil, network_acl = nil)
    @name = name
    @vpc = ":::::"
    @cidr_block = cidr_block
    @route_table = route_table 
    @network_acl = network_acl
    @availability_zone = availability_zone
  end
  
  def set_vpc(vpc)
    @vpc = vpc
  end
  
  def get_cf_type
    "AWS::EC2::Subnet"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"VpcId" => @vpc.generate_ref, "CidrBlock" => @cidr_block, "AvailabilityZone" => @availability_zone}
  end  
  
  def generate
    super
    unless @route_table.nil?
      name = "#{@name}RouteTableAssociation"
      rta = CfRouteTableAssociation.new(name, self, @route_table)
      @result += rta.generate      
    end
    unless @network_acl.nil?
      name = "#{@name}NetworkAclAssociation"
      acl = CfNetworkAclAssociation.new(name, self, @network_acl)
      @result += acl.generate            
    end
    @result
  end
  
end