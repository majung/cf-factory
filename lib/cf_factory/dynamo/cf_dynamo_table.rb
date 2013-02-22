require 'cf_factory/base/cf_base'
module CfFactory
class CfDynamoTable
  include CfBase  
  
  def initialize(name, read_capacity_units, write_capacity_units, hash_key_name, hash_key_type, range_key_name = nil, range_key_type = nil)
    @name = name
    @hash_key_name = hash_key_name
    @hash_key_type = hash_key_type
    @range_key_name = range_key_name
    @range_key_type = range_key_type
  end

  def set_deletion_policy(deletion_policy)
    @deletion_policy = deletion_policy
  end
          
  def get_cf_type
    "AWS::DynamoDB::Table"
  end
  
  def get_cf_attributes
    result = super
  end
  
  def get_cf_properties
    result = {} 
    if @range_key_name then
      result["KeySchema"] = { 
        "HashKeyElement" => { "AttributeName" => @hash_key_name, "AttributeType" => @hash_key_type },
        "RangeKeyElement" => { "AttributeName" => @range_key_name, "AttributeType" => @range_key_type}
      }
    else
      result["KeySchema"] = {
        "HashKeyElement" => { "AttributeName" => @hash_key_name, "AttributeType" => @hash_key_type }
      }
    end
    result
  end
    
end
end
