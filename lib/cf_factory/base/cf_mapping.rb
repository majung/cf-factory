module CfFactory
class CfMapping
  def initialize(name, target, from_to_hash)
    @name = name
    @target = target
    @from_to_hash = from_to_hash
  end
  
  def generate
    @result = ""
    @result += "    \"#{@name}\" : {\n"
    @from_to_hash.keys.each() {|key|
      value = @from_to_hash[key]
      @result += "      \"#{key}\"\t : { \"#{@target}\" : \"#{value}\" },\n"
    }
    @result = @result.chomp.chomp(",")
    @result += "\n    },"
  end
  
  def generate_ref(key)
    "{\"Fn::FindInMap\" : [ \"#{@name}\", #{CfHelper.generate_ref(key)}, \"#{@target}\" ]}"    
  end
  
  def map_from_region()
    "{\"Fn::FindInMap\" : [ \"#{@name}\", \"#{CfHelper.ref_current_region()}\", \"#{@target}\" ]}"
  end
end
end
