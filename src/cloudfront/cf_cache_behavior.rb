require 'base/cf_inner'

class CfCacheBehavior
  include CfInner
  
  attr_reader(:id)
      
  def additional_indent
    6
  end  
    
  def self.create_basic(target_origin_id, path_pattern, options = {})
    CfCacheBehavior.new(target_origin_id, CfForwardedValues.new(true), "allow-all", path_pattern, options)
  end
    
  def initialize(target_origin_id, forwarded_values, viewer_protocol_policy, path_pattern, options)
    @target_origin_id = target_origin_id
    @forwarded_values = forwarded_values
    @forwarded_values.add(2)
    @view_protocol_policy = viewer_protocol_policy
    @path_pattern = path_pattern
    @min_ttl = options[:min_ttl]
    @trusted_signers = options[:trusted_signers]
  end
  
  def get_cf_attributes
    result = {}
    result["TargetOriginId"] = @target_origin_id
    result["ForwardedValues"] = @forwarded_values.generate
    result["ViewerProtocolPolicy"] = @view_protocol_policy
    result["PathPattern"] = @path_pattern
    result["MinTTL"] = @min_ttl unless @min_ttl.nil?
    result["TrustedSigners"] = @trusted_signers unless @trusted_signers.nil?  
    result
  end
    
end
