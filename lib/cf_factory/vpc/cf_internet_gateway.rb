require 'cf_factory/base/cf_base'
require 'cf_factory/vpc/cf_attach_gateway'

module CfFactory
class CfInternetGateway
  include CfBase
  
  def initialize(name, vpn)
    @name = name
    @vpn = vpn
  end
  
  def get_cf_type
    "AWS::EC2::InternetGateway"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {}
  end
  
  def generate
    result = super
    result += CfAttachGateway.new("Attach#{@name}", @vpn, self).generate
    result
  end
  
end
end
