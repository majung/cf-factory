require 'aws'

class TemplateValidation
  def initialize(template_string, config_options)
    @template_string = template_string
    @config_options = config_options
  end
  
  def validate
    cf = AWS::CloudFormation.new(@config_options)
    response = cf.validate_template(@template_string)
    if response[:code] == "ValidationError"
      puts "Validation failed: #{response[:message]}"
    else
      puts "Validation successful"
    end
    response
  end
  
  def apply(parameters = {})
    cf = AWS::CloudFormation.new(@config_options)
    stack_name = "StackStartedFromEclipse#{Time.new.to_i}"
    puts "going to start stack #{stack_name} with parameters #{parameters.inspect}"
    stack = cf.stacks.create(stack_name, @template_string, :parameters => parameters, :capabilities => ["CAPABILITY_IAM"])
    puts "started stack with parameters: #{stack.parameters}"
  end
  
end