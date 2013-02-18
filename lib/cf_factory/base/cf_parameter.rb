require 'cf_factory/base/cf_base'

module CfFactory
class CfParameter
  include CfBase
  
  def initialize(name, description, type, properties_hash = {})
    @name = name
    @description = description
    @type = type
    @properties_hash = properties_hash
  end
  
  def get_cf_type
    @type
  end
  
  def get_cf_attributes
    @properties_hash.merge({"Description" => @description})
  end
  
  def get_cf_properties
    {}
  end  
  
end
end
