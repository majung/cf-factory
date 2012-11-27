require 'base/cf_base'
class CfCloudfrontDistribution
  include CfBase  
  
  def initialize(name, distribution_details)
    @name = name
    @distribution = distribution_details
  end
  
  def get_cf_type
    "AWS::CloudFront::Distribution"
  end
  
  def get_cf_attributes
    result = super
  end
  
  def get_cf_properties
    result = {}
    result["DistributionConfig"] = @distribution.generate 
    result
  end
  
end
