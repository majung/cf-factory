require 'base/cf_base'
require 'base/cf_helper'
require 'iam/cf_iam_instance_profile'

class CfIamGroup
  include CfBase
  
  def initialize(name, path, options)
    @name = name 
    @path = path
    @policies = options[:policies]
  end
    
  def get_cf_type
    "AWS::IAM::Group"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "Path" => @path
    }
    result["Policies"] = CfHelper.generate_inner_array(@policies) unless @policies.nil?
    result
  end
  
end