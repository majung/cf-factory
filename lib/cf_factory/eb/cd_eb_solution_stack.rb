module CfEbSolutionStack
  
  SUPPORTED_STACK_NAMES = {
    s32php54 => "32bit Amazon Linux running PHP 5.4",
    s64php54 => "64bit Amazon Linux running PHP 5.4",
    s32php53 => "32bit Amazon Linux running PHP 5.3",
    s64php53 => "64bit Amazon Linux running PHP 5.3",
    s64iis75 => "64bit Windows Server 2008 R2 running IIS 7.5",
    s64iis80 => "64bit Windows Server 2012 running IIS 8",
    s32tomcat7 => "32bit Amazon Linux running Tomcat 7",
    s64tomcat7 => "64bit Amazon Linux running Tomcat 7",
    s32tomcat6 => "32bit Amazon Linux running Tomcat 6",
    s64tomcat6 => "64bit Amazon Linux running Tomcat 6",
    s32python => "32bit Amazon Linux running Python",
    s64python => "64bit Amazon Linux running Python",
    s32ruby187 => "32bit Amazon Linux running Ruby 1.8.7",
    s64ruby187 => "64bit Amazon Linux running Ruby 1.8.7",
    s32ruby193 => "32bit Amazon Linux running Ruby 1.9.3",
    s64ruby193 => "64bit Amazon Linux running Ruby 1.9.3"
  }
    
  def is_valid_stack?(stack_id)
    SUPPORTED_STACK_NAMES.has_key?(stack_id)
  end

end

