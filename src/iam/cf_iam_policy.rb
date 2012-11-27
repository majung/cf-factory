require 'base/cf_inner'
require 'iam/cf_policy_document'

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