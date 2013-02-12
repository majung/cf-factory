require 'cf_factory/base/cf_inner'

class CfWebSiteConfig
  include CfInner
  
  attr_reader(:id)
      
  def additional_indent
    2
  end  
    
  def initialize(index_doc, error_doc)
    @index_doc = index_doc
    @error_doc = error_doc
  end
  
  def get_cf_attributes
    result = {}
    result["IndexDocument"] = @index_doc
    result["ErrorDocument"] = @error_doc
    result
  end
    
end