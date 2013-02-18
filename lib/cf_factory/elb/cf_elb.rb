require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'
require 'cf_factory/elb/cf_app_cookie_stickiness_policy'

module CfFactory
class CfElb
  include CfBase
  
  def initialize(name, options)
    @name = name
    @app_cookie_stickiness_policy = options[:app_cookie_stickiness_policy]
    @lb_cookie_stickiness_policy = options[:lb_cookie_stickiness_policy]
    @availability_zones = options[:availability_zones]
    @subnets = options[:subnets]
    @health_check = options[:health_check]
    @listeners = options[:listeners]
    @is_internal = options[:is_internal] || false 
    @security_groups = options[:security_groups]
    @instances = options[:instances] 
  end
    
  def get_cf_type
    "AWS::ElasticLoadBalancing::LoadBalancer"
  end
  
  def set_tags(tag_list)
    @tag_list = tag_list 
  end
    
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    optional = {}
    optional["AppCookieStickinessPolicy"] = CfHelper.generate_inner_array(@app_cookie_stickiness_policy) unless @app_cookie_stickiness_policy.nil?
    optional["LBCookieStickinessPolicy"] = CfHelper.generate_inner_array(@lb_cookie_stickiness_policy) unless @lb_cookie_stickiness_policy.nil?      
    optional["AvailabilityZones"] = @availability_zones unless @availability_zones.nil?
    optional["Subnets"] = CfHelper.generate_ref_array(@subnets) unless @subnets.nil?
    optional["HealthCheck"] = @health_check.generate
    optional["Listeners"] = CfHelper.generate_inner_array(@listeners) unless @listeners.nil? || @listeners.size == 0
    optional["Scheme"] = "internal" if @is_internal
    optional["SecurityGroups"] = CfHelper.generate_ref_array(@security_groups) unless @security_groups.nil?
    optional["Instances"] = CfHelper.generate_ref_array(@instances) unless @instances.nil? 
    all = {}
    all.merge!(optional)
    return all
  end
  
end
end
