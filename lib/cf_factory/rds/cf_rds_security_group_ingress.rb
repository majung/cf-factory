require 'cf_factory/base/cf_inner'

class CfRdsSecurityGroupIngress
  include CfInner
    
  def initialize(cidr = nil, ec2_sec_group = nil, ec2_sec_group_owner_id = nil)
    @cidr = cidr
    @ec2_sec_group = ec2_sec_group
    @ec2_sec_group_owner_id = ec2_sec_group_owner_id 
    @use_sg_id = true
  end
  
  def set_use_sg_id(flag)
    @use_sg_id = flag
  end
  
  def get_cf_attributes
    result = {}
    result["CIDRIP"] = @cidr unless @cidr.nil?
    if @use_sg_id
      result["EC2SecurityGroupId"] = @ec2_sec_group.generate_ref unless @ec2_sec_group.nil?
    else
      result["EC2SecurityGroupName"] = @ec2_sec_group.generate_ref unless @ec2_sec_group.nil?      
    end       
    result["EC2SecurityGroupOwnerId"] = @ec2_sec_group_owner_id unless @ec2_sec_group_owner_id.nil?            
    result
  end
  
end