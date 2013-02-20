module CfFactory
class CfMain
  def initialize(description, version = "2010-09-09")
    @description = description
    @version = version
    @mappings = []
    @parameters = []
    @outputs = []
    @resources = []
  end
  
  # Go through all resources and tag them with the specified array of tags.
  def apply_tags_to_all_resources(tag_list)
    @resources.each() {|resource|
      resource.set_tags(tag_list)
    }
  end
  
  def add_vpc(vpc)
    @resources << vpc
  end
  
  def add_elb(elb)
    @resources << elb
  end
  
  def add_mapping(mapping)
    @mappings << mapping
  end
  
  def add_parameter(parameter)
    @parameters << parameter
  end
  
  def add_output(parameter)
    @outputs << parameter
  end  
  
  def add_resource(resource)
    @resources << resource
  end
  
  def generate()
    @result = "{\n"
    generate_version
    generate_description
    generate_parameters
    generate_mappings unless @mappings.size == 0
    generate_resources
    generate_outputs
    @result += "}\n"
    @result
  end
  
  private
    
  def generate_version
    @result += "  \"Description\" : \"#{@description}\",\n"
  end
  
  def generate_description
    @result += "  \"AWSTemplateFormatVersion\" : \"#{@version}\",\n"
  end
  
  def generate_parameters
    @result += "  \"Parameters\" : {\n"
    @parameters.each() {|p|
      @result += p.generate
    }
    @result = @result.chomp.chomp(",")
    @result += "\n  },\n"
  end
  
  def generate_mappings
    @result += "  \"Mappings\" : {\n"
    @mappings.each() {|m|
      @result += m.generate
    }
    @result = @result.chomp(",")
    @result += "\n  },\n"      
  end  
  
  def generate_resources
    @result += "  \"Resources\" : {\n"
    @resources.each() do |resource|
      @result += resource.generate
    end
    @result = @result.chomp.chomp(",")
    @result += "\n  },\n"
  end  
  
  
  def generate_outputs
    @result += "  \"Outputs\" : {\n"
    @outputs.each() {|o|
      @result += o.generate
    }
    @result = @result.chomp.chomp(",")
    @result += "\n  }\n"
  end
    
end
end
