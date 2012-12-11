require 'base/cf_inner'

class CfForwardedValues
  include CfInner
      
  def additional_indent
    @additional_indent
  end  
    
  def add(add_indent)
    @additional_indent += add_indent
  end
  
  def initialize(query_string)
    @query_string = query_string
    @additional_indent = 6
  end
  
  def get_cf_attributes
    result = {}
    result["QueryString"] = @query_string
    result
  end
    
end