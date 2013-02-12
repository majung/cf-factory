require 'cf_factory/base/cf_base'
require 'cf_factory/base/cf_helper'

class CfRdsInstance
  VALID_TYPES = ["db.t1.micro", "db.m1.small","db.m1.medium","db.m1.large","db.m1.xlarge","db.m2.xlarge","db.m2.2xlarge","db.m2.4xlarge"]
  include CfBase
  
  def initialize(name, allocated_storage, engine, db_instance_class, master_username, master_userpassword, options = {})
    @name = name
    @allocated_storage = allocated_storage
    @db_instance_class = db_instance_class
    @engine = engine
    @master_username = master_username
    @master_userpassword = master_userpassword
    @multi_az = options[:multi_az]
    @security_groups = options[:security_groups]
    @subnet_group = options[:subnet_group]
    validate()
  end
  
  def get_cf_type
    "AWS::RDS::DBInstance"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {"AllocatedStorage" => @allocated_storage, 
      "DBInstanceClass" => @db_instance_class, 
      "Engine" => @engine, "MasterUsername" => @master_username,
      "MasterUserPassword" => @master_userpassword
    }
    result["MultiAZ"] = @multi_az unless @multi_az.nil?
    result["DBSecurityGroups"] = CfHelper.generate_ref_array(@security_groups) unless @security_groups.nil?
    result["DBSubnetGroupName"] = @subnet_group.generate_ref unless @subnet_group.nil?
    result
  end
  
  def add_rule(ingress_rule)
    @rules << ingress_rule
  end
  
  private
  
  def validate
    if !VALID_TYPES.include?(@db_instance_class)
      raise Exception.new("invalid type '#{@db_instance_class}' - supported classes are #{@VALID_TYPES.inspect}")
    end
  end
  
end