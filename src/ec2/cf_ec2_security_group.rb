require 'base/cf_base'
class CfEc2SecurityGroup
  include CfBase  
  
  def initialize(name, description, vpc = nil)
    @name = name
    @description = description
    @vpc = vpc
    @ingress_rules = []
    @egress_rules = []
      #TODO: already check name/description for invalid characters
  end
  
  def get_cf_type
    "AWS::EC2::SecurityGroup"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {"GroupDescription" => @description}
    result["VpcId"] = @vpc.generate_ref unless @vpc.nil?
    ingress = CfHelper.generate_inner_array(@ingress_rules)
    result["SecurityGroupIngress"] = ingress unless @ingress_rules.size == 0
    egress = CfHelper.generate_inner_array(@egress_rules)
    result["SecurityGroupEgress"] = egress unless @egress_rules.size == 0
    result
  end
  
  def add_ingress_rule(ingress_rule)
    @ingress_rules << ingress_rule
  end
  
  def add_egress_rule(egress_rule)
    @egress_rules << egress_rule
  end
  
end
