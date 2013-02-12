require 'cf_factory/base/cf_base'
class CfS3Bucket
  include CfBase  
  
  def initialize(name, options = {})
    @name = name
    @access_control = options[:access_control] 
  end

  def set_deletion_policy(deletion_policy)
    @deletion_policy = deletion_policy
  end
          
  def get_cf_type
    "AWS::S3::Bucket"
  end
  
  def get_cf_attributes
    result = super
  end
  
  def get_cf_properties
    result = {} 
    result["AccessControl"] = @access_control unless @access_control.nil? 
    result
  end
    
  def short_domain_name
    CfHelper.join([self.generate_ref, ".s3.amazonaws.com"])
  end
  
end
