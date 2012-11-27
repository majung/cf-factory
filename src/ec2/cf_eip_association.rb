require 'base/cf_base'

class CfEipAssociation
  include CfBase
    
  def initialize(name, eip, instance, network_interface, is_vpc = false) #TODO: network interface
    @name = name
    @eip = eip      
    @instance = instance
    @is_vpc = is_vpc
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
    result
  end
  
end