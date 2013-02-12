require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'

class CfCloudFormationSources
  include CfInner

  def initialize(source_list, additional_indent = 6) 
    @source_list = source_list
    @additional_indent = additional_indent
  end  
      
  def additional_indent
    6
  end
  
  def add_additional_indent
    @additional_indent += 2
  end
  
  def get_cf_attributes
    result = {}
    @source_list.each() {|key_value|
      key = key_value.keys.first
      value = key_value[key]
      result[key] = value
    }
    result
  end
      
end
