class CfHelper
  def self.generate_ref(cf_object_ref)
    "{ \"Ref\" : \"#{cf_object_ref}\" }"
  end
  
  def self.generate_att(resource_name, attribute_name)
    "{ \"Fn::GetAtt\" : [ \"#{resource_name}\", \"#{attribute_name}\" ] }"
  end
  
  def self.generate_ref_array(cf_array)
    result = "["
    cf_array.each() {|cf|
      result += "#{cf.generate_ref},"
    }
    result = result.chomp(",")
    result += "]"
    result    
  end
  
  def self.generate_inner_array(cf_array)
    result = "["
    cf_array.each() {|cf|
      result += "#{cf.generate()},"
    }
    result = result.chomp(",")
    result += "]"
    result
  end
  
  def self.generate_inner_list(cf_array)
    result = ""
    cf_array.each() {|cf|
      result += "#{cf.generate},\n"
    }
    result = result.chomp("\n").chomp(",") 
    result
  end
  
  def self.base64(string)
    base = "{ \"Fn::Base64\": #{string} }"
    return clean(base)
  end
  
  def self.join(array)
    "{ \"Fn::Join\" : [ \"\", #{array.inspect} ]}"
  end
  
  def self.clean(string)
    string.gsub(/\"{/,"{").gsub(/\"}/,"}").gsub(/}\"/,"}").gsub(/\"\[/,"[").gsub(/\"\]/,"]").gsub(/\\/,"")
  end
  
  def self.availability_zones(string = "")
    "{ \"Fn::GetAZs\" : \"#{string}\" }"
  end

  def self.ref_current_region()
    '{ "Ref" : "AWS::Region" }'
  end
  
end
