require 'base/cf_base'
require 'base/cf_helper'

class CfAsGroup
  include CfBase  
  
  def initialize(name, availability_zones, launch_config, load_balancers, max_size, min_size, options)
    @name = name
    @availability_zones = availability_zones
    @launch_config = launch_config
    @load_balancers  = load_balancers
    @max_size = max_size
    @min_size = min_size
    
    @cooldown = options[:cooldown]
    @desired_capacity = options[:desired_capacity]
    @health_check_grace_period = options[:health_check_grace_period]
    @health_check_type = options[:health_check_type]
    #TODO: NotificationConfiguration      
    @subnets = options[:subnets]
    validate()
  end
  
  def validate
    if @max_size < @min_size
      raise Exception.new("max size (#{@max_size}) must be equal or larger min size (#{@min_size})")
    end
    if @health_check_type == "ELB" && @health_check_grace_period.nil? 
      raise Exception.new("HealthCheckGracePeriod must be specified for ElasticLoadBalancer based health checks.")
    end
  end
  
  def get_cf_type
    "AWS::AutoScaling::AutoScalingGroup"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {"AvailabilityZones" => @availability_zones,
      "LaunchConfigurationName" => @launch_config.generate_ref,
      "LoadBalancerNames" => CfHelper.generate_ref_array(@load_balancers),
      "MaxSize" => @max_size,
      "MinSize" => @min_size
    }
    result["Cooldown"] = @cooldown unless @cooldown.nil?
    result["DesiredCapacity"] = @desired_capacity unless @desired_capacity.nil?
    result["HealthCheckGracePeriod"] = @health_check_grace_period.to_i unless @health_check_grace_period.nil?
    result["HealthCheckType"] = @health_check_type unless @health_check_type.nil?  
    result["VPCZoneIdentifier"] = CfHelper.generate_ref_array(@subnets) unless @subnets.nil?
    result
  end
  
  def add_ingress_rule(ingress_rule)
    @ingress_rules << ingress_rule
  end
  
  def add_egress_rule(egress_rule)
    @egress_rules << egress_rule
  end
  
end
