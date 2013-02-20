require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'

module CfFactory
class CfAsLaunchConfig
  include CfBase  
  
  def initialize(name, image_id, instance_type, options)
    @name = name
    @image_id = image_id
    @instance_type = instance_type
    
    @user_data = options[:user_data]
    @key_name = options[:key_name]
    @security_groups = options[:security_groups]
    @spot_price = options[:spot_price]
    #TODO: a couple of properties missing
    validate()
  end
  
  def get_cf_type
    "AWS::AutoScaling::LaunchConfiguration"
  end
  
  def get_cf_attributes
    super
  end
  
  def get_cf_properties
    result = {"ImageId" => @image_id,
      "InstanceType" => @instance_type
    }
    result["UserData"] = CfHelper.base64(@user_data) unless @user_data.nil?
    result["KeyName"] = @key_name unless @key_name.nil?
    result["SecurityGroups"] = CfHelper.generate_ref_array(@security_groups) unless @security_groups.nil?
    result["SpotPrice"] = @spot_price unless @spot_price.nil?
    result
  end
  
  def add_ingress_rule(ingress_rule)
    @ingress_rules << ingress_rule
  end
  
  def add_egress_rule(egress_rule)
    @egress_rules << egress_rule
  end

  private
  
  def validate
    raise Exception.new("instance type #{@instance_type} is not supported") unless CfEc2Instance::SUPPORTED_TYPES.include?(@instance_type)
  end
    
end
end
