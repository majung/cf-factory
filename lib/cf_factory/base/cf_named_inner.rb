require 'cf_factory/base/cf_helper'

# Defines a named JSON resource with attributes to be defined in get_cf_attributes(). NamedInner objects can be passed to other NamedInner objects as attributes
# for recursive definitions.

module CfNamedInner
  def get_cf_attributes
    raise Exception.new("must be defined")
  end
    
  def additional_indent()
    if @indent.nil?
      @indent = 0
    end
    @indent
  end
    
  def set_indent(indent)
    @indent = indent
  end
  
  def generate()
    indent = " "*self.additional_indent()
    @result =  "#{indent}\"#{@name}\" : {\n"
    attributes = self.get_cf_attributes
    @result += hash_to_string(attributes)
    @result += "\n#{indent}}"
    @result
  end  

  def hash_to_string(hash, indent="")
    output = ""
    indent = " "*additional_indent()
    hash.keys.each() do |key|
      value = hash[key]
      output += indent
      #puts "value.class.to_s = #{value.class.to_s} indent = #{indent.size}"
      case value.class.to_s
        when "Hash"
          output += "     \"#{key}\" : \n{#{hash_to_string(value,indent+5)}},\n"
        else
          if value.class.to_s == self.class.to_s
            #recursive usage
            output += "     \"#{key}\" : { \n#{value.generate},\n"
          else
            #any other primitive type
            output += "     \"#{key}\" : #{set_quotes(value)},\n"
          end
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
