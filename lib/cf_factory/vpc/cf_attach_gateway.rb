require 'cf_factory/base/cf_base'
class CfAttachGateway
  include CfBase
    
  def initialize(name, vpc = nil, internet_gateway = nil, vpn_gateway = nil)
    @name = name
    @vpc = vpc
    @internet_gateway = internet_gateway
    @vpn_gateway = vpn_gateway 
  end
    
  def get_cf_type
    "AWS::EC2::VPCGatewayAttachment"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}
    result["VpcId"] = @vpc.generate_ref
    result["InternetGatewayId"] = @internet_gateway.generate_ref unless @internet_gateway.nil?
    result["VpnGatewayId"] = @vpn_gateway.generate_ref unless @vpn_gateway.nil?
    result
  end
  
end