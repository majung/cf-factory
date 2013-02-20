require 'cf_factory/base/cf_inner'

module CfFactory
class CfEc2Tag
  include CfInner  
  
  def initialize(key, value, options = {})
    @key = key
    @value = value
    @propagate_at_launch = options[:propagate_at_launch]
  end
     
  def set_propagate_at_launch(pal)
    @propagate_at_launch = pal
  end
   
  def get_cf_attributes
    result = {"Key" => @key,
     "Value" => @value
    }
    result["PropagateAtLaunch"] = @propagate_at_launch unless @propagate_at_launch.nil?
    result
  end

  def clone
    options = {} 
    if @propagate_at_launch
      options[:propagate_at_launch] = @propagate_at_launch 
    end
    CfEc2Tag.new(@key,@value,options)
  end
    
end
end
