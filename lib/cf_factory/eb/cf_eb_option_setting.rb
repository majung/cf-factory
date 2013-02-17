require 'cf_factory/base/cf_inner'

class CfEbOptionSetting
  include CfInner
  def initialize(namespace, option_name, value)
    @namespace=namespace
    @option_name = option_name
    @value = value
  end

  def get_cf_attributes
    { "Namespace" => @namespace,
      "OptionName" => @option_name,
      "Value" => @value
    }
  end
end
