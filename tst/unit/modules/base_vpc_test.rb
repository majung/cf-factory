require 'test_helper'

class BaseVpcTest < TestHelper
  
  def setup
    puts "setup..."
  end
  
  def teardown
    puts "tear down"
  end
  
  def test_test
    cf = CfMain.new("test")
    vpc = BaseVpc.new("Matthias","11.11.0.0/16",2,4,["eu-west-1a","eu-west-1b"])
    res = vpc.add_to_template(cf)
    puts cf.generate
    assert true
  end
    
end