require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'

module CfFactory
class CfCloudFormationInit
  include CfInner

  #config: key value pair of config-sets
  def initialize(configs)
    @configs = configs
    @name = "AWS::CloudFormation::Init"
  end
    
  def get_cf_attributes
    result = {}    
    @configs.each() {|c|
      result[c.get_name] = c.generate
    }
    result
  end
  
  def generate
    generate_name
  end
  
end
end
