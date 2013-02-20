require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'

module CfFactory
class CfSqsQueue
  include CfBase
  
  def initialize(name, options = {})
    @name = name
    @visibility_timeout = options[:visibility_timeout]
  end
  
  def get_cf_type
    "AWS::SQS::Queue"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}
    result["VisibilityTimeout"] = @visibility_timeout unless @visibility_timeout.nil?
    result
  end
  
end
end
