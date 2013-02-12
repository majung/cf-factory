require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'

class CfAsScalingPolicy
  include CfBase  
  
  def initialize(name, auto_scaling_group, adjustment_type, scaling_adjustment, options = {})
    @name = name
    @auto_scaling_group = auto_scaling_group
    @adjustment_type = adjustment_type
    @scaling_adjustment = scaling_adjustment
    @cooldown = options[:cooldown]
  end
    
  def get_cf_type
    "AWS::AutoScaling::ScalingPolicy"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "AutoScalingGroupName" => @auto_scaling_group.generate_ref,
      "AdjustmentType" => @adjustment_type,
      "ScalingAdjustment" => @scaling_adjustment
    }
    result["Cooldown"] = @cooldown unless @cooldown.nil?
    result
  end
    
end
