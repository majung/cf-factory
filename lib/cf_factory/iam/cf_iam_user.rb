require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'
require 'cf_factory/iam/cf_iam_instance_profile'

class CfIamUser
  include CfBase
  
  def initialize(name, path, options = {})
    @name = name 
    @path = path
    @policies = options[:policies]
    @login_profile = options[:login_profile]
    @groups = options[:groups]
  end
    
  def get_cf_type
    "AWS::IAM::User"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "Path" => @path
    }
    result["Policies"] = CfHelper.generate_inner_array(@policies) unless @policies.nil?
    result["LoginProfile"] = "XXX" unless @login_profile.nil?
    result["Groups"] = CfHelper.generate_ref_array(@groups) unless @groups.nil?
    result
  end
  
end