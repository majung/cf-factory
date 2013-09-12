require 'cf_factory/base/cf_base'

module CfFactory
class CfEipAssociation
  include CfBase
    
  def initialize(name, options = {})
    @name = name
    @eip = options[:eip]      
    @instance = options[:instance]
    @network_interface = options[:network_interface]
    @is_vpc = options[:is_vpc] || false
  end
  
  def get_cf_type
    "AWS::EC2::EIPAssociation"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}
    result["InstanceId"] = @instance.generate_ref unless @instance.nil?
    result["EIP"] = @eip.generate_ref unless @is_vpc
    result["AllocationId"] = @eip.retrieve_attribute("AllocationId") if @is_vpc
    result["NetworkInterfaceId"] = @network_interface.generate_ref unless @network_interface.nil?
    result
  end
  
end
end
