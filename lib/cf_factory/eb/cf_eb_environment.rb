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
    result = {}
    result["ApplicationName"] = @application_name
    result["Description"] = @description
    result["TemplateName"] = @template_name
    result["VersionLabel"] = @version_label
    result["SolutionStackName"] = SUPPORTED_STACK_NAMES[@solution_stack_name] unless @solution_stack_name.nil?
    result["CNAMEPrefix"] = @cname_prefix unless @cname_prefix.nil?
    result["OptionSettings"] = @option_settings unless @option_settings.nil?
    result["OptionsToRemove"] = @options_to_remove unless @options_to_remove.nil?
    result
  end

  def validate
    if not @solution_stack_name.nil?
      raise Exception.new("stack name not supported: #{@solution_stack_name}") unless is_valid_stack?(@solution_stack_name)
    end
  end


end
                 
end
