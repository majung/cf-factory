require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'

module CfFactory
class CfEbApplication
  include CfBase  
  
  def initialize(name, description, application_versions, configuration_templates)
    @name = name
    @description = description
    @application_versions = application_versions
    @configuration_templates = configuration_templates
  end

  def set_tags(tag_list)
    @tag_list = tag_list 
  end
    
  def set_deletion_policy(deletion_policy)
    @deletion_policy = deletion_policy
  end
          
  def get_cf_type
    "AWS::ElasticBeanstalk::Application"
  end
  
  def get_cf_attributes
    super
  end
  
  def get_cf_properties
    result = {}
    result["ApplicationVersions"] = CfHelper.generate_inner_array(@application_versions)
    result["ConfigurationTemplates"] = CfHelper.generate_inner_array(@configuration_templates)
    result["Description"] = @description
    result
  end

  
end
end
