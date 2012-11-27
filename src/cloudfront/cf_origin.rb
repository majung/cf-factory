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