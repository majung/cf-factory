require 'cf_factory/base/cf_base'



module CfFactory
class CfEbEnvironment
  include CfBase
  include CfEbSolutionStack

  def initialize(name, application_name, cname_prefix, description, option_settings, options_to_remove, 
                 solution_stack_name, template_name, version_label)
    @name = name
    @application_name = application_name
    @cname_prefix = cname_prefix
    @description = description
    @option_settings = option_settings
    @options_to_remove = options_to_remove
    @solution_stack_name = solution_stack_name
    @template_name = template_name
    @version_label = version_label

    validate

  end

  def get_cf_type
    "AWS::ElasticBeanstalk::Environment"
  end
  
  def get_cf_attributes
    super
  end

  def get_cf_properties
    {
      "ApplicationName" => @application_name,
      "CNAMEPrefix" => @cname_prefix,
      "Description" => @description,
      "OptionSettings" => @option_settings,
      "OptionsToRemove" => @options_to_remove,
      "SolutionStackName" => SUPPORTED_STACK_NAMES[@solution_stack_name],
      "TemplateName" => @template_name,
      "VersionLabel" => @version_label
    }      

  end

  def validate
    raise Exception.new("stack name not supported: #{@solution_stack_name}") unless is_valid_stack?(@solution_stack_name)
  end


end
                 
end
