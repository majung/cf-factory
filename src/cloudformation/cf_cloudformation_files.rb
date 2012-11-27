require 'base/cf_base'
require 'base/cf_inner'
require 'base/cf_helper'

class CfCloudFormationFiles
  include CfInner

  def initialize(files)
    @files = files
    @additional_indent = 4
  end  
      
  def additional_indent
    @additional_indent += 2
  end
    
  def get_cf_attributes
    result = {} 
    @files.each() {|file|
      result[file.get_name] = file.generate
    }      
    result
  end
      
end
