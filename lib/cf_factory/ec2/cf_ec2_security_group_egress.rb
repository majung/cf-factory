require 'cf_factory/base/cf_inner'

class CfEc2SecurityGroupEgress
  include CfInner
    
  def additional_indent
    2
  end  
  
  def initialize(ip_protocol, from_port, to_port, cidr = nil, dest_group = nil)
    @ip_protocol = ip_protocol
    @from_port = from_port
    @to_port = to_port
    @cidr = cidr
    @dest_group = dest_group 
  end
  
  def get_cf_attributes
    result = {}
    result["CidrIp"] = @cidr unless @cidr.nil?
    result["DestinationSecurityGroupId"] = @dest_group.generate_ref unless @dest_group.nil?
    result["FromPort"] = @from_port
    result["ToPort"] = @to_port
    result["IpProtocol"] = @ip_protocol
    result
  end
  
end