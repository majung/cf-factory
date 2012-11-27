require 'base/cf_inner'

class CfS3OriginConfig
  include CfInner
      
  def additional_indent
    6
  end  
  
  
  def initialize(options = {})
    @origin_access_identity = options[:origin_access_identity]  
  end
  
  def get_cf_attributes
    result = {}
    result["OriginAccessIdentity"] = @origin_access_identity unless @origin_access_identify.nil?
    result
  end
  
  def is_custom?
    false
  end
    
end