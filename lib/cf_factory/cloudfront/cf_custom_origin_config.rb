require 'cf_factory/base/cf_inner'

class CfCustomOriginConfig
  PROTOCOL_VALUES = ["http-only","match-viewer"]
  include CfInner
      
  def additional_indent
    6
  end  
  
  
  def initialize(protocol, options = {})
    @protocol = protocol
    @http_port = options[:http_port]  
    @https_port = options[:https_port]
    validate()
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
   
  private
  
  def validate
    raise Exception.new("protocol must be within #{PROTOCOL_VALUES}") unless PROTOCOL_VALUES.include?(@protocol)
  end
   
end