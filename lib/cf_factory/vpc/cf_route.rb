require 'cf_factory/base/cf_base'

class CfRoute
  include CfBase
    
  def initialize(name, dest_cidr, gateway = nil, instance = nil, eni = nil)
    @name = name
    @dest_cidr = dest_cidr  
    @gateway  = gateway
    @instance = instance
    @eni = eni
  end
  
  def set_route_table(route_table)
    @route_table = route_table
  end
  
  def add_association()
  end
  
  def get_cf_type
    "AWS::EC2::Route"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    options = {}
    unless @gateway.nil?
      options["GatewayId"] = @gateway.generate_ref
    end
    unless @instance.nil?
      options["InstanceId"] = @instance.generate_ref
    end
    unless @eni.nil?
      options["NetworkInterfaceId"] = @eni.generate_ref
    end
    {"RouteTableId" => @route_table.generate_ref, "DestinationCidrBlock" => @dest_cidr}.merge(options)
  end  
    
end