require 'base/cf_inner'

class CfDefaultCacheBehavior
  include CfInner
      
  def additional_indent
    4
  end  
    
  def initialize(target_origin_id, forwarded_values, viewer_protocol_policy, options = {})
    @target_origin_id = target_origin_id
    @forwarded_values = forwarded_values
    @viewer_protocol_policy = viewer_protocol_policy
      
    @min_ttl = options[:min_ttl]
    @trusted_signers = options[:trusted_signers]    
  end
  
  def get_cf_attributes
    result = {}
    result["TargetOriginId"] = @target_origin_id
    result["ForwardedValues"] = @forwarded_values.generate
    result["ViewerProtocolPolicy"] = @viewer_protocol_policy
    result["MinTTL"] = @min_ttl unless @min_ttl.nil?
    result
  end
    
end