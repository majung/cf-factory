require 'base/cf_inner'

class CfEc2SecurityGroupIngress
  include CfInner
    
  def additional_indent
    2
  end  

  def initialize(ip_protocol, from_port, to_port, cidr = nil, source_group = nil, source_group_owner_id = nil)
    @ip_protocol = ip_protocol
    @from_port = from_port
    @to_port = to_port
    @cidr = cidr
    @source_group = source_group
    @source_group_owner_id = source_group_owner_id 
  end
  
  def get_cf_attributes
    result = {}
    result["CidrIp"] = @cidr unless @cidr.nil?
    result["SourceSecurityGroupId"] = @source_group.generate_ref unless @source_group.nil?
    result["SourceSecurityGroupOwnerId"] = @source_group_owner_id unless @source_group_owner_id.nil?
    result["FromPort"] = @from_port
    result["ToPort"] = @to_port
    result["IpProtocol"] = @ip_protocol
    result
  end
  
end