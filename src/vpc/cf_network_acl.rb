require 'base/cf_base'
class CfNetworkAcl
  include CfBase
  
  def initialize(name)
    @name = name
    @entries = []
  end
  
  def add_network_acl_entry(network_acl_entry)
    network_acl_entry.set_network_acl(self)
    @entries << network_acl_entry
  end
  
  def set_vpc(vpc)
    @vpc = vpc
  end
  
  def get_cf_type
    "AWS::EC2::NetworkAcl"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"VpcId" => @vpc.generate_ref}
  end  
  
  def generate
    super
    @entries.each() {|entry|
      @result += entry.generate
    }
    @result
  end
  
end