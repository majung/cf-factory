require 'base/cf_inner'

class CfEc2Tag
  include CfInner  
  
  def initialize(key, value, options = {})
    @key = key
    @value = value
    @propagate_at_launch = options[:propagate_at_launch]
  end
      
  def get_cf_attributes
    result = {"Key" => @key,
     "Value" => @value
    }
    result["PropagateAtLaunch"] = @propagate_at_launch unless @propagate_at_launch.nil?
    result
  end
  
end
