require 'cf_factory/base/cf_helper'

module CfBase
  def get_name
    @name
  end
  
  def get_cf_type
    raise Exception.new("must be defined")
  end
    
  def get_deletion_policy
    @deletion_policy
  end
  
  def get_cf_attributes
    result = {}
    result["Metadata"] = @meta_data.generate unless @meta_data.nil?
    result
  end
  
  def get_cf_properties
    raise Exception.new("must be defined")
  end
  
  def generate_ref
    CfHelper.generate_ref(self.get_name)
  end
  
  def retrieve_attribute(attribute)
    CfHelper.generate_att(@name, attribute)
  end
  
  def set_meta_data(meta_data)
    @meta_data = meta_data
  end
    
  def set_tags(tag_list)
    #should be overwritten by those resources that support tags 
  end
    
  def hash_to_string(hash, indent=0)
    output = ""
    hash.keys.each() do |key|
      value = hash[key]
      output += " " * indent
      case value.class.to_s
      when "Hash"
        output += "        \"#{key}\" : \n{#{hash_to_string(value,indent+5)}},\n"
      else
        output += "        \"#{key}\" : #{set_quotes(value)},\n"
      end
    end
    output
    output = output.chomp().chomp(",")

  end

  def generate
    @result = ""
    @result += "    \"#{@name}\" : {\n"
    unless self.get_cf_type() == nil
      @result += "      \"Type\" : \"#{self.get_cf_type()}\",\n"
    end
    unless self.get_deletion_policy() == nil
      @result += "      \"DeletionPolicy\" : \"#{self.get_deletion_policy()}\",\n"
    end            
    attributes = self.get_cf_attributes  
    unless attributes.size == 0
      @result += "#{hash_to_string(attributes)},\n"
    end
    #
    properties = self.get_cf_properties
    properties["Tags"] = CfHelper.generate_inner_array(@tag_list) unless @tag_list.nil?
    unless properties.size == 0
      @result += "      \"Properties\" : {\n"
      @result += hash_to_string(properties)
      @result += "\n      }"  
    end
    @result = @result.chomp.chomp(",")
    @result += "\n    },\n"
  end
  
  # Sets leading and trailing quotes
  def set_quotes(value)
    if value.class.to_s == "String"
      if value.delete(" ").start_with?("{") || value.delete(" ").start_with?("[") 
        value
      else
        "\"#{value}\""
      end
    else
      value
    end
  end
  
end
