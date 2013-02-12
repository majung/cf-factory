require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'
require 'cf_factory/base/cf_helper'

class CfCloudFormationConfig
  include CfInner

  def get_name
    @name
  end
  
  def initialize(name, sources, commands, files, packages)
    @name = name
    @sources = sources
    @commands = commands
    @files = files
    @packages = packages
  end  
      
  def additional_indent
    4
  end
    
  def get_cf_attributes
    result = {}
    result["sources"] = CfHelper.clean(@sources.generate) unless @sources.nil?
    result["commands"] = @commands.generate unless @commands.nil?
    result["files"] = @files.generate unless @files.nil?
    result["packages"] = @packages.generate unless @packages.nil?
    result
  end
      
end
