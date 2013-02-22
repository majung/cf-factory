require 'cf_factory/base/cf_inner'

module CfFactory
class CfAsUpdatePolicy
  include CfInner
  
  def additional_indent
    4
  end  
    
  def initialize(update_policy_name, max_batch_size, min_instances_in_service, pause_time)
    @name = update_policy_name
    @max_batch_size = max_batch_size
    @min_instances_in_service = min_instances_in_service
    @pause_time = pause_time
  end
  
  def get_cf_attributes
    result = {}
    result["MaxBatchSize"] = @max_batch_size
    result["MinInstancesInService"] = @min_instances_in_service
    result["PauseTime"] = @pause_time
    result
  end  
end
end
