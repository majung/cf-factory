require 'base/cf_inner'

class CfElbAliasTarget
  include CfInner
    
  def additional_indent
    2
  end  

  def initialize(elb)
    @elb = elb 
  end
  
  def get_cf_attributes
    result = {}
    result["HostedZoneId"] = @elb.retrieve_attribute("CanonicalHostedZoneNameID")
    result["DNSName"] = @elb.retrieve_attribute("CanonicalHostedZoneName")
    result
  end
  
end
