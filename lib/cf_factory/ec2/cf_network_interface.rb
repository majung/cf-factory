require 'cf_factory/base/cf_base'

module CfFactory
class CfNetworkInterface
  include CfBase  
  
  def initialize(name, subnet, options = {})
    @name = name
    @subnet = subnet
    #
    @private_ip = options[:private_ip]
    @description = options[:description]
    @security_groups = options[:security_groups]
    @source_dst_check = options[:source_dest_check]
  end
  
  def get_cf_type
    "AWS::EC2::NetworkInterface"
  end
  
  def set_tags(tag_list)
    @tag_list = tag_list 
  end
    
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}
    result["Description"] = @description unless @description.nil?      
    result["SourceDestCheck"] = @source_dest_check unless @source_dst_check.nil?
    result["GroupSet"] = CfHelper.generate_ref_array(@security_groups) unless @security_groups.nil?
    result["SubnetId"] = @subnet.generate_ref unless @subnet.nil?
    result["PrivateIpAddress"] = @private_ip unless @private_ip.nil?
    result
  end

end
end
