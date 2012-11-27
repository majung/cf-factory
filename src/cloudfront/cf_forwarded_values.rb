require 'base/cf_inner'

class CfForwardedValues
  include CfInner
      
  def additional_indent
    6
  end  
    
  def initialize(query_string)
    @query_string = query_string
  end
  
  def get_cf_attributes
    result = {}
    result["QueryString"] = @query_string
    result
  end
    
end