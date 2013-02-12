require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'
require 'cf_factory/elb/cf_app_cookie_stickiness_policy'

class CfIamInstanceProfile
  include CfBase
  
  def initialize(name, path, roles)
    @name = name 
    @path = path
    @roles = roles
  end
    
  def get_cf_type
    "AWS::IAM::InstanceProfile"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "Path" => @path,
      "Roles" => "["+@roles.collect() {|r| CfHelper.generate_ref(r)}.join(",")+"]"
    }
    result
  end
  
end