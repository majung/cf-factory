require 'help/include_libraries'

#INCOMPLETE: seems as if the OriginAccessIdentity cannot be created via CloudFormation

# CloudFormation template that creates an S3 bucket that allows private access
# to a cloudfront distribution.
# What remains at the end:
# - create content in S3 bucket
# - create cloudfront access keys (Account -> Security Credentials)
# - use a library to sign that content  
cf = CfMain.new("CloudFront for private content")
s3_bucket = CfS3.new("majung-cloudfront-private-1")
cf.add_resource(s3_bucket)

#cloudfront
origin = CfCustomOriginConfig.new("http-only",:http_port => 80)
origin_config = CfOrigin.new(elb.retrieve_attribute("DNSName") ,"CF001", origin)
origin_config = CfS3OriginConfig.new(options)
default_cache_behavior = CfDefaultCacheBehavior.new(origin_config.id,CfForwardedValues.new(true),"allow-all",{:min_ttl => 0})
distribution_details = CfDistributionConfig.new([origin_config],default_cache_behavior,true)
cloudfront_distribution = CfCloudfrontDistribution.new("MyDistribution",distribution_details)
cf.add_resource(cloudfront_distribution)

