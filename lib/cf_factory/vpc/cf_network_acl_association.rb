require 'cf_factory/base/cf_base'

module CfFactory
class CfNetworkAclAssociation
  include CfBase
    
  def initialize(name, subnet, network_acl)
    @name = name
    @subnet = subnet
    @network_acl = network_acl
  end
  
  def get_cf_type
    "AWS::EC2::SubnetNetworkAclAssociation"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"SubnetId" => @subnet.generate_ref, "NetworkAclId" => @network_acl.generate_ref}
  end  
  
end
end
