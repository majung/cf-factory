require 'cf_factory'
require './test/test_cf_factory.rb'

class CfScriptReaderTest < CfFactory::TestHelper
  
  def setup
    puts "setup..."
  end
  
  def teardown
    puts "tear down"
  end
  
  def test_test
    puts "testing something..."
    assert true
  end
  
  def test_init
    sr = CfFactory::CfScriptReader.new("test/fixtures/blurb.txt")
    assert_not_nil sr
  end
  
  def test_apply_args
    sr = CfFactory::CfScriptReader.new("test/fixtures/blurb.txt")    
    sr.apply_arguments("param1","param2")
    assert true
  end
  
  def test_generate
    sr = CfFactory::CfScriptReader.new("test/fixtures/blurb.txt")
    sr.apply_arguments("param1","param2")
    res = sr.generate()
    exp = "This is just to test if the parameters param1 and \nalso param2 are correctly integrated into this blurb."
    puts res
    assert_equal exp, res
  end
  
  def test_generate_with_indent
    sr = CfFactory::CfScriptReader.new("test/fixtures/blurb.txt",3)    
    sr.apply_arguments("param1","param2")
    res = sr.generate()
    exp = "   This is just to test if the parameters param1 and \n   also param2 are correctly integrated into this blurb."
    puts res
    assert_equal exp, res    
  end
  
end
