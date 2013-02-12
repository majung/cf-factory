require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'
require 'cf_factory/base/cf_helper'

class CfCloudFormationCommand
  include CfInner

  def get_name
    @name
  end
  
  def initialize(name, command, options = {})
    @name = name
    @command = command
      #
    @env = options[:env]
    @cwd = options[:cwd]
    @test = options[:test]
    @ignore_errors = options[:ignore_errors]
    @additional_indent = 6
  end  
      
  def additional_indent
    @additional_indent += 2
  end
    
  def get_cf_attributes
    result = {} 
    result['command'] = @command
    result['env'] = @env unless @env.nil?
    result['cwd'] = @cwd unless @cwd.nil?
    result['test'] = @test unless @test.nil?
    result['ignoreErrors'] = @ignore_errors unless @ignore_errors.nil?
    result
  end
      
end
