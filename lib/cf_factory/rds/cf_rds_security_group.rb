require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'

class CfRdsSecurityGroup
  include CfBase
  
  def initialize(name, description, vpc = nil)
    @name = name
    @description = description
    @vpc = vpc
    @rules = []
  end
  
  def get_cf_type
    "AWS::RDS::DBSecurityGroup"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    rules_array = CfHelper.generate_inner_array(@rules)
    result = {"GroupDescription" => @description, "DBSecurityGroupIngress" => rules_array}
    result["EC2VpcId"] = @vpc.generate_ref unless @vpc.nil?
    result
  end
  
  def add_rule(ingress_rule)
    @rules << ingress_rule
  end
  
end