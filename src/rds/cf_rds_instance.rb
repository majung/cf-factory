require 'base/cf_base'
require 'base/cf_helper'

class CfRdsInstance
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
  
end