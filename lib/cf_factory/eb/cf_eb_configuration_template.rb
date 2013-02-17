require 'cf_factory/base/cf_inner'

class CfEbConfigurationTemplate
  include CfInner
  def initialize(template_name, description, option_settings, solution_stack_name)
    @template_name = template_name
    @description = description
    @option_settings = option_settings
    @solution_stack_name = solution_stack_name
  end

  def get_cf_attributes
    { "TemplateName" => @template_name,
      "Description" => @description,
      "OptionSettings" => (option_settings.map {|opt| opt.generate}).join(',')
    }
  end
end
