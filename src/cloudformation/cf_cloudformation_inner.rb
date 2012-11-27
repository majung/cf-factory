require 'base/cf_base'
require 'base/cf_inner'

class CfCloudFormationInner
  include CfInner

  def initialize(key_value_list, indent)
    @key_value_list = key_value_list
    @additional_indent = indent
  end
          
  def additional_indent
    @additional_indent
  end
  
  def get_cf_attributes
    result = {}
    puts "key_value_list = #{@key_value_list}"
    @key_value_list.each() {|key_value_pair|
      key = key_value_pair.keys.first
      value = key_value_pair[key]
      puts "key_value_pair = #{key_value_pair} key = #{key} value = #{value}"
      result[key] = value
    }
    result
  end
    
end
