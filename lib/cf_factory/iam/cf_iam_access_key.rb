require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'
require 'cf_factory/iam/cf_iam_instance_profile'

module CfFactory
class CfIamAccessKey
  include CfBase
  
  def initialize(name, user_name, status, options = {})
    @name = name 
    @status = status
    @user_name = user_name
    @serial = options[:serial]
  end
    
  def get_cf_type
    "AWS::IAM::AccessKey"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "Status" => @status,
      "UserName" => @user_name
    }
    result["Serial"] = @serial unless @serial.nil?
    result
  end
  
end
end
