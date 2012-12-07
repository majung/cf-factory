#not yet working

require 'base/cf_base'
class CfRoute53RecordSetGroup
  include CfBase  
  
  def initialize(name, record_sets, options)
    raise Exception.new("don't use for now")
    @name = name
    @record_sets = record_sets
    @hosted_zone_id = options[:hosted_zone_id]
    @hosted_zone_name = options[:hosted_zone_name]
    @comment = options[:comment]      
    validate()
  end
    
  def get_cf_type
    "AWS::Route53::RecordSetGroup"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}      
    result["RecordSets"] = CfHelper.generate_inner_array(@record_sets)
    result["Comment"] = @comment unless @comment.nil?
    result["HostedZoneId"] = @hosted_zone_id unless @hosted_zone_id.nil?
    result["HostedZoneName"] = @hosted_zone_name unless @hosted_zone_name.nil? 
    result
  end

  private
  
  def validate
    if @hosted_zone_id.nil? && @hosted_zone_name.nil?
      raise Exception.new("either :hosted_zone_id or :hosted_zone_name must be specified")
    end
  end
  
end
