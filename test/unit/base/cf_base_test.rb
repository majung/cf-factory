require 'cf_factory'
require './test/test_cf_factory.rb'

class CfBaseTest < CfFactory::TestHelper
  
  def setup
    puts "setup..."
  end
  
  def teardown
    puts "tear down"
  end
  
  def test_instantiate
    obj = DummyBase.new("NameGiven", "att1-value",'att2-value')
  end
  
  def test_generate
    obj = DummyBase.new("NameGiven", "att1-value",'att2-value')
    res = obj.generate
    exp = 
    '    "NameGiven" : {
      "Type" : "AWS::Test::Dummy",
      "Properties" : {
        "Attribute1" : "att1-value",
        "Attribute2" : "att2-value"
      }
    },
'
    puts exp.inspect
    puts res.inspect
    assert_equal exp, res
  end
  
  #########
    
  class DummyBase
    include CfFactory::CfBase
    
    def initialize(name, att1, att2)
      @name = name
      @att1 = att1
      @att2 = att2
    end
    
    def get_cf_type
      "AWS::Test::Dummy"
    end
    
    def get_cf_attributes
      {} #"TestAttribute" => "43"}
    end
    
    def get_cf_properties
      result = {}
      result["Attribute1"] = @att1
      result["Attribute2"] = @att2
      result
    end

  end
  
end
