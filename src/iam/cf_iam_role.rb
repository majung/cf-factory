require 'base/cf_base'
require 'base/cf_helper'
require 'iam/cf_iam_instance_profile'

class CfIamRole
  include CfBase
  
  def initialize(name, path, options)
    @name = name 
    @path = path
    @policies = options[:policies]
  end
    
  def get_cf_type
    "AWS::IAM::Role"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {
      "Path" => @path,
      "AssumeRolePolicyDocument" => assume_role_ec2() #no other supported right now
    }
    result["Policies"] = CfHelper.generate_inner_array(@policies) unless @policies.nil?
    result
  end
  
  def generate
    result = super
    result += CfIamInstanceProfile.new(@name+"Profile", @path, [@name]).generate
  end
  
  private
  
  def assume_role_ec2
    ' {
          "Statement":[
            {
              "Effect":"Allow",
              "Principal":{
                  "Service":[
                      "ec2.amazonaws.com"
                  ]
              },
              "Action":[
                  "sts:AssumeRole"
              ]
            }
          ] 
        }'
  end
  
end