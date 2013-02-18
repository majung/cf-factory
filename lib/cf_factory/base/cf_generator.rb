module CfFactory
class CfGenerator
  def initialize(indent)
    @indent = indent
  end
  
  def self.add_line(indent, input, result)
    result += "\n#{self.indent(indent, input)}"
  end
  
  def self.indent(indent, string)
    result = ""
    string.each_line() {|s|
      result += "#{" "*indent}#{s}"      
    }
    result
  end
  
end
end
