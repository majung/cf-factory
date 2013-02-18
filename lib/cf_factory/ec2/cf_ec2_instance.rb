require 'cf_factory/base/cf_base'
module CfFactory
class CfEc2Instance
  SUPPORTED_TYPES = ["t1.micro","m1.small","m1.medium","m1.large","m1.xlarge",
    "m2.xlarge","m2.2xlarge","m2.4xlarge","m3.xlarge","m3.2xlarge","c1.medium", "c1.xlarge",
    "cc1.4xlarge","cc2.8xlarge", "cg1.4xlarge", "hi1.4xlarge"]
  include CfBase  
  
  def initialize(name, image_id, instance_type, options = {})
    @name = name
    @image_id = image_id
    @instance_type = instance_type
    @keyname = options[:keyname]
    @subnet = options[:subnet]
    @vpc_security_groups = options[:vpc_security_groups]
    @security_groups = options[:security_groups]      
    @source_dest_check = options[:source_dest_check]
    @user_data = options[:user_data]
    @availability_zone = options[:availability_zone]
    validate()
  end

  def set_tags(tag_list)
    @tag_list = tag_list 
  end
    
  def set_deletion_policy(deletion_policy)
    @deletion_policy = deletion_policy
  end
          
  def get_cf_type
    "AWS::EC2::Instance"
  end
  
  def get_cf_attributes
    result = super
  end
  
  def get_cf_properties
    result = {"ImageId" => CfHelper.clean(@image_id),
      "InstanceType" => @instance_type,
    }
    result["KeyName"] = @keyname  unless @keyname.nil?
    result["SubnetId"] = @subnet.generate_ref unless @subnet.nil?
    result["SecurityGroupIds"] = CfHelper.generate_ref_array(@vpc_security_groups) unless @vpc_security_groups.nil?
    result["SecurityGroups"] = CfHelper.generate_ref_array(@security_groups) unless @security_groups.nil?      
    result["SourceDestCheck"] = @source_dest_check unless @source_dest_check.nil?
    result["UserData"] = CfHelper.base64(@user_data) unless @user_data.nil? 
    result["AvailabilityZone"] = @availability_zone unless @availability_zone.nil?
    result
  end

  def assign_eip
    #TODo
  end
  
  private
  
  def validate
    raise Exception.new("instance type not supported #{@instance_type}") unless SUPPORTED_TYPES.include?(@instance_type)    
  end
  
end
end
