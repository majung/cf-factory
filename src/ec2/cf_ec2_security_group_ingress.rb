require 'base/cf_inner'

class CfEc2SecurityGroupIngress
  include CfInner
    
  def additional_indent
    2
  end  

  def initialize(ip_protocol, from_port, to_port, cidr = nil, source_group = nil, options = {})
    @ip_protocol = ip_protocol
    @from_port = from_port
    @to_port = to_port
    @cidr = cidr
    @source_group = source_group
    @source_group_owner_id = options[:source_group_owner_id]
    @use_sg_id = true
  end
  
  def set_use_sg_id(flag)
    @use_sg_id = flag
  end
  
  def get_cf_attributes
    result = {}
    result["CidrIp"] = @cidr unless @cidr.nil?
    if @use_sg_id
      result["SourceSecurityGroupId"] = @source_group.generate_ref unless @source_group.nil?
    else
      result["SourceSecurityGroupName"] = @source_group.generate_ref unless @source_group.nil?      
    end      
    result["SourceSecurityGroupOwnerId"] = @source_group_owner_id unless @source_group_owner_id.nil?
    result["FromPort"] = @from_port
    result["ToPort"] = @to_port
    result["IpProtocol"] = @ip_protocol
    result
  end
  
end