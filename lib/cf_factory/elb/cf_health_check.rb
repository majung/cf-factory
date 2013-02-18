require 'cf_factory/base/cf_inner'

module CfFactory
class CfHealthCheck
  include CfInner
  
  def initialize(healthy_threshold, interval, target, timeout, unhealthy_threshold)
    @healthy_threshold = healthy_threshold
    @interval = interval
    @target = target
    @timeout = timeout
    @unhealthy_threshold = unhealthy_threshold 
  end
      
  def get_cf_attributes
    {"HealthyThreshold" => @healthy_threshold,
      "Interval" => @interval,
      "Target" => @target,
      "Timeout" => @timeout,
      "UnhealthyThreshold" => @unhealthy_threshold
    }
  end
    
end
end
