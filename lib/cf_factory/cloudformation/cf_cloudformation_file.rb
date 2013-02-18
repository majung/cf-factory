require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'
require 'cf_factory/base/cf_helper'

module CfFactory
class CfCloudFormationFile
  include CfInner

  def get_name
    @name
  end
  
  def initialize(name, content, group, owner, mode, options = {})
    @name = name
    @content = content
    @group = group
    @owner = owner
    @mode = mode
    @source = options[:source]
      #
    @additional_indent = 6
    #TODO: authentication + encoding missing
  end  
      
  def additional_indent
    @additional_indent += 2
  end
    
  def get_cf_attributes
    result = {} 
    result["content"] = @content
    result["group"] = @group
    result["owner"] = @owner      
    result["mode"] = @mode      
    result["source"] = @source unless @source.nil?  
    result
  end
      
end
end
