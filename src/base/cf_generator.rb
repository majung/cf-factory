class CfGenerator
  def initialize(indent)
    @indent = indent
  end
  
  
  
  def self.add_line(indent, input, result)
    result += "\n#{self.indent(indent, input)}"
  end
  
  def self.indent(indent, string)
    "#{" "*indent}#{string}"
  end
  
end
