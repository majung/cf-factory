require 'base/cf_inner'

class CfDistributionConfig
  include CfInner
  
  def additional_indent
    2
  end  
  
  def initialize(origins, default_cache_behaviour, enabled = true, options = {})
    @origins = origins
    @default_cache_behaviour = default_cache_behaviour
    @enabled = enabled
    
    @cache_behaviors = options[:cache_behaviors] 
    @aliases = options[:aliases] 
    @logging = options[:logging]
  end
  
  def get_cf_attributes
    result = {}
    result["Origins"] = CfHelper.generate_inner_array(@origins)
    result["DefaultCacheBehavior"] = @default_cache_behaviour.generate
    result["Enabled"] = @enabled
    result["Logging"] = @logging.generate unless @logging.nil?
    result["Aliases"] = @aliases.inspect unless @aliases.nil?
    result["CacheBehaviors"] = CfHelper.generate_inner_array(@cache_behaviors)
    result
  end
  
end
