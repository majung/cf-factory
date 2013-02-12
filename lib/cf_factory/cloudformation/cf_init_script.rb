class CfInitScript
  # Every parameter-string will be transformed into something like { "Ref" : "<parameter>" }
  def initialize(script, parameter_array)
    @script = script
    @parameter_array = parameter_array
    prepare
  end
  
  def user_data
    @user_data
  end
  
  def self.create_basic(resource_id, access_key, secret_key)
    stack = CfHelper.generate_ref("AWS::StackName")
    CfInitScript.new(basic_script(), [stack, resource_id, access_key, secret_key])
  end
  
  private
  
  def validate
    if @script.occurences_of("<!par!") != @parameter_array.size
      raise Exception.new("the number of parameters does not correspond to the number of placeholders in the script")
    end
  end
  
  # Looks for all occurences of <!#par#!> in the script and builds a string that is base64-encoded and joined
  # and where all those occurences are replaced with the parameter name specified in the constructor.
  def prepare
    #divide along parameters
    #@script.strip!()
    divided_script = @script.split("<!par!>")    
    script_with_params = []
    count = 0
    divided_script.each() {|part|
      #puts "part [#{count}] = #{part}"
      part.split("\n").each() {|line|
        next if line.strip.size == 0
        script_with_params << "#{line.lstrip} " #TODO: make this work with the line-breaks
        script_with_params << "\n"
      }
      script_with_params.delete_at(script_with_params.size()-1)
      script_with_params << @parameter_array[count]
      count += 1
    }
    puts script_with_params
    puts script_with_params.inspect
    join = CfHelper.join(script_with_params)
    puts join
    @user_data = join
  end

  def self.basic_script
    init_script = "
       #!/bin/bash -v
       /opt/aws/bin/cfn-init -s <!par!> -r <!par!>
       --access-key <!par!>
       --secret-key <!par!>        
        || error_exit 'Failed to run cfn-init'
    "
  end
  
def self.basic_script_with_update
  init_script = "
     #!/bin/bash -v
     yum update -y aws-cfn-bootstrap
     # Run cfn-init for config
     /opt/aws/bin/cfn-init -s <!par!> -r <!par!>
     --access-key <!par!>
     --secret-key <!par!>        
      || error_exit 'Failed to run cfn-init'
  "
end  
  
end