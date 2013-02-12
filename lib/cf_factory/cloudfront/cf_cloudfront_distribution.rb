require 'cf_factory/base/cf_base'

class CfCloudfrontDistribution
  include CfBase  
  
  def initialize(name, distribution_details)
    @name = name
    @distribution = distribution_details
  end
  
  def set_tags(tag_list)
    @tag_list = tag_list 
  end
    
  def self.create_s3_distribution(name, s3_bucket, origin_options = {}, cache_behaviour_options = {}, distribution_options = {})
    s3_origin = CfS3OriginConfig.new
    origin_config = CfOrigin.new(s3_bucket.short_domain_name(),s3_bucket.generate_ref,s3_origin, origin_options)
    default_cache_behavior = CfDefaultCacheBehavior.new(origin_config.id,CfForwardedValues.new(true),"allow-all", cache_behaviour_options)
    distribution_details = CfDistributionConfig.new([origin_config],default_cache_behavior, true, distribution_options)
    CfCloudfrontDistribution.new(name, distribution_details)
  end
  
  def self.create_elb_distribution(name, elb, origin_options = {}, cache_behaviour_options = {}, distribution_options = {})
    custom_origin = CfCustomOriginConfig.new("http-only")
    origin_config = CfOrigin.new(elb.retrieve_attribute("DNSName"),elb.generate_ref,custom_origin,origin_options)
    default_cache_behavior = CfDefaultCacheBehavior.new(origin_config.id,CfForwardedValues.new(true),"allow-all", cache_behaviour_options)
    distribution_details = CfDistributionConfig.new([origin_config],default_cache_behavior, true, distribution_options)
    CfCloudfrontDistribution.new(name, distribution_details)
  end
  
  def self.create_domain_distribution(name, origin_domain, origin_id, origin_options = {}, cache_behaviour_options = {}, distribution_options = {})
    custom_origin = CfCustomOriginConfig.new("http-only")
    origin_config = CfOrigin.new(origin_domain,origin_id,custom_origin,origin_options)
    default_cache_behavior = CfDefaultCacheBehavior.new(origin_config.id,CfForwardedValues.new(true),"allow-all", cache_behaviour_options)
    distribution_details = CfDistributionConfig.new([origin_config],default_cache_behavior, true, distribution_options)
    CfCloudfrontDistribution.new(name, distribution_details)
  end  
  
  def self.create_multi_origin_distribution(name, origins, default_cache_behavior, cache_behaviors, distribution_options = {})
    distribution_details = CfDistributionConfig.new(origins,default_cache_behavior, true, distribution_options.merge({:cache_behaviors => cache_behaviors}))
    CfCloudfrontDistribution.new(name, distribution_details)
  end

  def self.create_multi_origin_distribution_old(name, origins, cache_behaviour_options = {}, distribution_options = {})
    default_cache_behavior = CfDefaultCacheBehavior.new("XXX was origin_config.id",CfForwardedValues.new(true),"allow-all", cache_behaviour_options)
    distribution_details = CfDistributionConfig.new(origins,default_cache_behavior, true, distribution_options)
    CfCloudfrontDistribution.new(name, distribution_details)
  end
        
  def get_cf_type
    "AWS::CloudFront::Distribution"
  end
  
  def get_cf_attributes
    result = super
  end
  
  def get_cf_properties
    result = {}
    result["DistributionConfig"] = @distribution.generate 
    result
  end
  
end
