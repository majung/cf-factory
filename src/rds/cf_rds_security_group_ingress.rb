require 'base/cf_inner'

class CfRdsSecurityGroupIngress
  include CfInner
    
  def initialize(cidr = nil, ec2_sec_group = nil, ec2_sec_group_owner_id = nil)
    @cidr = cidr
    @ec2_sec_group = ec2_sec_group
    @ec2_sec_group_owner_id = ec2_sec_group_owner_id 
  end
  
  def get_cf_attributes
    result = {}
    result["CIDRIP"] = @cidr unless @cidr.nil?
    result["EC2SecurityGroupId"] = @ec2_sec_group.generate_ref unless @ec2_sec_group.nil?
    result["EC2SecurityGroupOwnerId"] = @ec2_sec_group_owner_id unless @ec2_sec_group_owner_id.nil?            
    result
  end
  
end