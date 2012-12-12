require 'base/cf_helper'

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
      @result += "#{indent}            \"#{key}\" : #{set_quotes(value)},\n"
    }
    #
    @result = @result.chomp.chomp(",")
    @result += "\n#{indent}      }"
    @result += "\n#{indent}        }"
  end
  
  def generate()
    indent = " "*additional_indent()
    @result = "#{indent}"
    @result += "#{indent}{\n"
    attributes = self.get_cf_attributes
    attributes.keys.each() {|key|
      value = attributes[key]
      @result += "#{indent}          \"#{key}\" : #{set_quotes(value)},\n"
    }
    #
    @result = @result.chomp.chomp(",")
    @result += "\n#{indent}        }"
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