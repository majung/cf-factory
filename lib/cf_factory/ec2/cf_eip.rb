require 'cf_factory/base/cf_base'
class CfEip
  include CfBase  
  
  def initialize(name, instance = nil, is_vpc = false)
    @name = name
    @instance = instance
    @domain = is_vpc ? "vpc" : nil
  end
  
  def get_cf_type
    "AWS::EC2::EIP"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}
    result["InstanceId"] = @instance.generate_ref unless @instance.nil?      
    result["Domain"] = @domain unless @domain.nil?
    result
  end

end
