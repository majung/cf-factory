require 'cf_factory/base/cf_inner'

class CfLogging
  include CfInner
  
  attr_reader(:id)
      
  def additional_indent
    4
  end  
    
  def initialize(bucket, prefix)
    @bucket = bucket
    @prefix = prefix
  end
  
  def get_cf_attributes
    result = {}
    result["Bucket"] = @bucket.retrieve_attribute("DomainName")
    result["Prefix"] = @prefix
    result
  end
    
end