require 'cf_factory/base/cf_helper'

module CfInner
  def get_cf_attributes
    raise Exception.new("must be defined")
  end
  
  def additional_indent
    0
  end
  
  def generate_name()
    indent = " "*additional_indent()
    @result = "#{indent}"
    @result += "#{indent}{\n"
    attributes = self.get_cf_attributes
    @result += "#{indent}          \"#{@name}\" : {\n"
    attributes.keys.each() {|key|
      value = attributes[key]
      if value.method_defined? :get_cf_attributes
        @result += "#{indent}            \"#{key}\" : #{value.get_cf_attributes},\n}"
      else
        @result += "#{indent}            \"#{key}\" : #{set_quotes(value)},\n"
      end
    }
    
    @result = @result.chomp.chomp(",")
    @result += "\n#{indent}      }"
    @result += "\n#{indent}        }"
  end
  
  def generate()
    indent = " "*additional_indent()
    @result = "#{indent}"
    @result += "#{indent}{\n"
    attributes = self.get_cf_attributes
    @result += hash_to_string(attributes)

    @result += "\n#{indent}        }"
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
