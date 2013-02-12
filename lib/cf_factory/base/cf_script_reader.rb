# Reads a file, integrates the specified arguments, and generates indented output taken specified parameters into account
class CfScriptReader
  def initialize(file_to_read, indentation = 0)
    @file = file_to_read
    @indent = indentation
  end
  
  def apply_arguments(*arguments)
    @arguments = arguments
    puts @arguments.inspect     
  end
  
  def generate()
    contents = File.open(@file, "r") {|f| f.read}
    count = 1
    @arguments.each() {|arg|
      pattern = /<\$#{count}>/
      puts "pattern = #{pattern.inspect}"
      contents.gsub!(pattern, arg)
      count += 1
    }
    result = ""
    contents.each_line do |line|
      result += "#{' '*@indent}#{line}"
    end
    result
  end
    
  private
  
  
end