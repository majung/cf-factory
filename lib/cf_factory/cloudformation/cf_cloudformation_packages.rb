require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'
require 'cf_factory/base/cf_helper'

module CfFactory
class CfCloudFormationPackages
  include CfInner
  
  def initialize(package_definitions)
    @package_definitions = package_definitions
    #
    @additional_indent = 6
  end
      
  def additional_indent
    @additional_indent
  end
    
  def get_cf_attributes
    result = {}    
    sort_packages_by_type()
    @packages_by_type.keys.each() {|package_type|
      result["#{package_type}"] = "{\n#{CfHelper.generate_inner_list(@packages_by_type[package_type])}\n#{" "*(@additional_indent+10)}}"
    }
    result
  end
      
  private
  
  def sort_packages_by_type
    @packages_by_type = {}
    @package_definitions.each() {|package_definition|
      packages_of_type = @packages_by_type[package_definition.get_package_type]
      if packages_of_type.nil?
        packages_of_type = []
        @packages_by_type[package_definition.get_package_type] = packages_of_type
      end
      packages_of_type << package_definition
    }
    @packages_by_type
  end
  
end
end
