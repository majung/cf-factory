require 'base/cf_inner'

class CfCustomOriginConfig
  include CfInner
      
  def additional_indent
    6
  end  
  
  
  def initialize(protocol, options = {})
    @protocol = protocol
    @http_port = options[:http_port]  
    @https_port = options[:https_port]
  end
  
  def get_cf_attributes
    result = {}
    result["OriginProtocolPolicy"] = @protocol
    result["HTTPPort"] = @http_port unless @http_port.nil?
    result["HTTPSPort"] = @https_port unless @https_port.nil?
    result
  end
  
  def is_custom?
    true
  end
    
end