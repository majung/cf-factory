require 'cf_factory/base/cf_inner'
require 'cf_factory/iam/cf_policy_document'

module CfFactory
class CfIamPolicy
  include CfInner  
  
  def initialize(policy_name, policy_doc)
    @policy_name = policy_name
    @policy_doc = policy_doc
  end
      
  def get_cf_attributes
    {"PolicyName" => @policy_name,
      "PolicyDocument" => @policy_doc.generate
    }
  end

end
end
