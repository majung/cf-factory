require 'base/cf_base'
require 'base/cf_inner'
require 'base/cf_helper'

class CfCloudFormationPackage
  include CfInner

  def get_package_type
    @package_type
  end
  
  def initialize(package_type, package_name, versions, options = {})
    @package_type = package_type
    @package_name = package_name
    @versions = versions
      #
    @additional_indent = 6
    #TODO: authentication + encoding missing
  end  
      
  def additional_indent
    @additional_indent += 12
  end
    
  def get_cf_attributes
    result = {} 
    result["#{@package_name}"] = @versions.inspect
    result
  end
  
  def generate
    CfGenerator.indent(self.additional_indent, "\"#{@package_name}\" : #{@versions.inspect}")
  end
end
