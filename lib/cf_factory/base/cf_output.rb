require 'cf_factory/base/cf_base'

class CfOutput
  include CfBase
  
  def initialize(name, description, value)
    @name = name
    @description = description
    @value = value
  end
  
  def get_cf_type
    nil
  end
  
  def get_cf_attributes
    {"Description" => @description, "Value" => @value}
  end
  
  def get_cf_properties
    {}
  end  
  
end
