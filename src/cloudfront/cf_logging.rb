require 'base/cf_inner'

class CfLogging
  include CfInner
  
  attr_reader(:id)
      
  def additional_indent
    4
  end  
    
  def initialize(bucket_domain, prefix)
    @bucket = bucket_domain #mylogs.s3.amazonaws.com
    @prefix = prefix
  end
  
  def get_cf_attributes
    result = {}
    result["Bucket"] = @bucket
    result["Prefix"] = @prefix
    result
  end
    
end