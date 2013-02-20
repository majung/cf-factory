require 'cf_factory/base/cf_inner'

module CfFactory
class CfListener
  include CfInner
  
  def initialize(instance_port, instance_protocol, load_balancer_port, protocol, policy_names = nil, ssl_certificate_id = nil)
    @instance_port = instance_port
    @instance_protocol = instance_protocol 
    @load_balancer_port = load_balancer_port
    @protocol = protocol     
    @policy_names = policy_names   
    @ssl_certificate_id = ssl_certificate_id 
  end
      
  def get_cf_attributes
    result = {"InstancePort" => @instance_port,
      "InstanceProtocol" => @instance_protocol,
      "LoadBalancerPort" => @load_balancer_port,
      "Protocol" => @protocol,
    }
    result["PolicyNames"] = @policy_names unless @policy_names.nil?
    result["SSLCertificateId"] = @ssl_certificate_id unless @ssl_certificate_id.nil?
    result
  end
    
end
end
