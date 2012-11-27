require 'base/cf_inner'

class CfDistributionConfig
  include CfInner
  
  def additional_indent
    2
  end  
  
  def initialize(origins, default_cache_behaviour, enabled, options = {})
    @origins = origins
    @default_cache_behaviour = default_cache_behaviour
    @enabled = enabled
    
    @aliases = options[:aliases] 
  end
  
  def get_cf_attributes
    result = {}
    result["Origins"] = CfHelper.generate_inner_array(@origins)
    result["DefaultCacheBehavior"] = @default_cache_behaviour.generate
    result["Enabled"] = @enabled
    result
  end
  
end
