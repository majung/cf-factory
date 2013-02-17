require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_inner'

class CfEbApplicationVersion 
  include CfInner
  def initialize(description, source_bundle_bucket, source_bundle_key, version_label)
    @description = description
    @source_bundle_bucket = source_bundle_bucket
    @source_bundle_key = source_bundle_key
    @version_label = version_label
  end



  def get_cf_attributes
    { "Description" =>  @description,
      "SourceBundle" => { "S3Bucket" => @source_bundle_bucket, "S3Key" => @source_bundle_key },
      "VersionLabel" => @version_label }
  end


end
