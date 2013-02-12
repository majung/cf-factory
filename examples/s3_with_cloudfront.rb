require 'help/include_libraries'

# CloudFormation template for Atraveo. 2-Tiered web-application with load-balancing.
cf = CfMain.new("S3 Bucket with CloudFront distribution")

####### input parameters

####### mappings

####### resources

s3_bucket = CfS3Bucket.new("OriginBucket")
cf.add_resource(s3_bucket)
s3_log_bucket = CfS3Bucket.new("LogBucket")

#cloudfront
logging = CfLogging.new(s3_bucket,"MyDistribution")
options = {:logging => logging}
cloudfront_distribution = CfCloudfrontDistribution.create_s3_distribution("MyS3Distribution",s3_bucket)
cf.add_resource(cloudfront_distribution)

####### output parameters
s3_domain = CfOutput.new("S3Domain","Domain name of S3 bucket",s3_bucket.retrieve_attribute("DomainName"))
cf.add_output(s3_domain)
cloudfront_domain = CfOutput.new("CloudfrontDomain", "Endpoint of the CloudFront distribution", cloudfront_distribution.retrieve_attribute("DomainName"))
cf.add_output(cloudfront_domain)

cf_json = cf.generate 
puts cf_json

config_options = YAML.load_file("aws_config.yml")
validator = TemplateValidation.new(cf_json, config_options)
validator.validate()
validator.apply()

#puts "the reference for the VPC : #{vpc.generate_ref}"