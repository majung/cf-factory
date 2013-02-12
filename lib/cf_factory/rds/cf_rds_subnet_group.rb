require 'cf_factory/base/cf_base'

class CfRdsSubnetGroup
  include CfBase  
  
  def initialize(name, description)
    @name = name
    @description = description
    @subnets = []
  end
  
  def get_cf_type
    "AWS::RDS::DBSubnetGroup"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    subnet_array = @subnets.collect() {|s| s.generate_ref}.join(",")
    {"DBSubnetGroupDescription" => @description, "SubnetIds" => "[#{subnet_array}]"}
  end  
  
  def add_subnet(subnet)
    @subnets << subnet
  end
  
end