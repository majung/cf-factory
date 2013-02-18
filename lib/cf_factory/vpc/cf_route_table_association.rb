require 'cf_factory/base/cf_base'

module CfFactory
class CfRouteTableAssociation
  include CfBase
    
  def initialize(name, subnet, route_table)
    @name = name
    @subnet = subnet
    @route_table = route_table
  end
  
  def get_cf_type
    "AWS::EC2::SubnetRouteTableAssociation"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"SubnetId" => @subnet.generate_ref, "RouteTableId" => @route_table.generate_ref}
  end  
  
end
end
