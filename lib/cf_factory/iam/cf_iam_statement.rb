require 'cf_factory/base/cf_inner'

class CfIamStatement
  include CfInner  
  
  def initialize(effect, action, resource)
    @effect = effect
    @action = action
    @resource = resource
  end
      
  def get_cf_attributes
    {"Effect" => @effect,
     "Action" => @action,
     "Resource" => @resource
    }
  end

  def additional_indent
    4
  end
  
end
