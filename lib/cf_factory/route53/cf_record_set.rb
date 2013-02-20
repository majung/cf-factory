require 'cf_factory/base/cf_base'
module CfFactory
class CfRecordSet
  include CfInner
  
  def initialize(name, record_name, record_type, options)
    @name = name
    @record_name = record_name
    @record_type = record_type
    
    @comment = options[:comment]
    @region = options[:region]
    @hosted_zone_id = options[:hosted_zone_id]
    @hosted_zone_name = options[:hosted_zone_name]      
    @region = options[:region]
    @ttl = options[:ttl]
    @resource_records = options[:resource_records]
    @weight = options[:weight]
    @set_identifier = options[:set_identifier]
    @alias_target = options[:alias_target]
    validate()
  end
    
  def get_cf_type
    "AWS::Route53::RecordSet"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    result = {}
    result["Name"] = @record_name
    result["Type"] = @record_type
    result["Comment"] = @comment unless @comment.nil?
    result["HostedZoneId"] = @hosted_zone_id unless @hosted_zone_id.nil?
    result["HostedZoneName"] = @hosted_zone_name unless @hosted_zone_name.nil?
    result["Region"] = @region unless @region.nil?
    result["TTL"] = @ttl unless @ttl.nil?
    result["Weight"] = @weight unless @weight.nil?
    result["SetIdentifier"] = @set_identifier unless @set_identifier.nil? 
    result["ResourceRecords"] = @resource_records.inspect unless @resource_records.nil?
    result["AliasTarget"] = @alias_target.generate unless @alias_target.nil?
    result
  end

  private
  
  def validate
    if @hosted_zone_id.nil? && @hosted_zone_name.nil?
      raise Exception.new("either :hosted_zone_id or :hosted_zone_name must be specified")
    end
    if !@ttl.nil? && @resource_records.nil?
      raise Exception.new("when :ttl specified, :resource_records must also be specified (and vice versa)")
    end
    if !@weight.nil? && @set_identifier.nil?
      raise Exception.new("when :weight specified, :set_identifier must also be specified (and vice versa)")
    end
  end
  
end
end
