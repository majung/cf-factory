require 'cf_factory'
require './test/test_cf_factory.rb'

class CfNamedInnerTest < CfFactory::TestHelper
  
  def setup
    puts "setup..."
  end
  
  def teardown
    puts "tear down"
  end
  
  def test_instantiate
    obj = DummyNamedInner.new("NameGiven", "43",'ABC')
  end
  
  def test_generate_simple
    obj = DummyNamedInner.new("NameGiven", "43",'ABC')
    res = obj.generate
    puts res
    puts "inspected: #{res.inspect}" 
    assert_equal obj.expected_1, res
  end
  
  def test_generate_indent
    obj = DummyNamedInner.new("NameGiven", "43",'ABC')
    obj.set_indent(10)
    res = obj.generate
    puts res
    puts "inspected: #{res.inspect}" 
    assert_equal obj.expected_2, res
  end
  
  def test_generate_recursive
    sub_obj = DummyNamedInner.new("InnerObject", "att1-value",'att2-value')
    sub_obj.set_indent(8)
    obj = DummyNamedInner.new("OuterObject", "att3-value",sub_obj)
    res = obj.generate
    puts res
    puts "inspected: #{res.inspect}"
    puts "expected : #{obj.expected_3.inspect}" 
    assert_equal obj.expected_3, res
  end      
  
  #########
    
  class DummyNamedInner
    include CfNamedInner
    
    def initialize(name, att1, att2)
      @name = name
      @att1 = att1
      @att2 = att2
    end
    
    def get_cf_type
      "AWS::Test::Dummy"
    end
    
    def get_cf_attributes
      {
        "Attribute1" => @att1,
        "Attribute2" => @att2
      }
    end
    
    def get_cf_properties
      {}
    end

    def expected_1
'"NameGiven" : {
     "Attribute1" : "43",
     "Attribute2" : "ABC"
}'
    end

    def expected_2
'          "NameGiven" : {
               "Attribute1" : "43",
               "Attribute2" : "ABC"
          }'
    end    
     
    def expected_3
'"OuterObject" : {
     "Attribute1" : "att3-value",
     "Attribute2" : { 
        "InnerObject" : {
             "Attribute1" : "att1-value",
             "Attribute2" : "att2-value"
        }
}'
    end
       
  end
  
end
