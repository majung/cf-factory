require 'cf_factory'
require './test/test_cf_factory.rb'

class BaseVpcTest < CfFactory::TestHelper
  
  def setup
    puts "setup..."
  end
  
  def teardown
    puts "tear down"
  end
  
  def test_test
    cf = CfFactory::CfMain.new("test")
    vpc = CfFactory::BaseVpc.new("Matthias","11.11.0.0/16",2,4,["eu-west-1a","eu-west-1b"])
    res = vpc.add_to_template(cf)
    puts cf.generate
    assert true
  end
    
end
