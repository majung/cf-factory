require 'base/cf_inner'

class CfOrigin
  include CfInner
  
  attr_reader(:id)
      
  def additional_indent
    4
  end  
    
  def initialize(domain_name, id, origin, options = {})
    @domain_name = domain_name 
    @id = id
    @origin = origin
  end
  
  def self.create_s3_origin(s3_bucket, options = {})
    s3_origin_config = CfS3OriginConfig.new
    CfOrigin.new(s3_bucket.short_domain_name(),s3_bucket.generate_ref,s3_origin_config, options)
  end
  
  def self.create_elb_origin(elb, options = {})
    custom_origin_config = CfCustomOriginConfig.new("http-only")
    CfOrigin.new(elb.retrieve_attribute("DNSName"),elb.generate_ref,custom_origin_config, options)    
  end
  
  def get_cf_attributes
    result = {}
    result["DomainName"] = @domain_name
    result["Id"] = id
    if @origin.is_custom?
      result["CustomOriginConfig"] = @origin.generate
    else
      result["S3OriginConfig"] = @origin.generate
    end
    result
  end
    
end