require 'base/cf_base'

class CfNetworkAclEntry
  include CfBase
  
  def initialize(name, rule_number, protocol, rule_action, egress, cidr_block, from_port, to_port)
    @name = name
    @rule_number = rule_number
    @protocol = protocol
    @rule_action = rule_action
    @egress = egress
    @cidr_block = cidr_block    
    @from_port = from_port
    @to_port = to_port
  end
  
  def set_network_acl(network_acl)
    @network_acl = network_acl
  end
  
  def get_cf_type
    "AWS::EC2::NetworkAclEntry"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"NetworkAclId" => @network_acl.generate_ref, "CidrBlock" => @cidr_block, 
      "Protocol" => @protocol.to_i, "RuleNumber" => @rule_number.to_i, "RuleAction" => @rule_action, "Egress" => @egress
    }#TODO: port ranges
  end  
  
  
end