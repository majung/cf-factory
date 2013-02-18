require 'cf_factory'

class IpMaskTest < TestHelper
  include CfFactory
  def setup
    puts "setup..."
  end
  
  def teardown
    puts "tear down"
  end
  
  def test_in_range
    ip = IpMask.create("10.0.0.0",16)
    assert_equal true, ip.are_all_in_range?(IpMask.create("10.0.0.0",16))
    assert_equal false, ip.are_all_in_range?(IpMask.create("10.0.0.0",8))
    assert_equal false, ip.are_all_in_range?(IpMask.create("10.1.0.0",16))
    assert_equal true, ip.are_all_in_range?(IpMask.create("10.0.0.0",24))
    assert_equal false, ip.are_all_in_range?(IpMask.create("10.1.0.0",24))
  end
  
  def test_divide_individually
    ip = IpMask.create("10.0.0.0",16)
    address_size_array = [256,256,256,256]
    div = ip.divide_individually(address_size_array)
    assert_equal 4, div.size
    expected = [IpMask.new("10.0.0.0",24), IpMask.new("10.0.1.0",24), IpMask.new("10.0.2.0",24), IpMask.new("10.0.3.0",24)]
    assert_equal expected, div
  end
    
  def test_equals
    ip = IpMask.create("10.0.0.0",16)
    assert_equal true, ip == ip
    assert_equal true, ip == IpMask.create("10.0.0.0",16)
    assert_equal true, ip == IpMask.create("10.0.0.1",16) #since mask is cleaned
    assert_equal false, ip == IpMask.new("10.0.0.1",16) #since mask is cleaned    
    assert_equal false, ip == IpMask.create("10.1.0.0",16) 
    assert_equal false, ip == IpMask.create("10.0.0.0",18)    
    assert_equal false, IpMask.new("10.0.0.1",16) == ip #since mask is cleaned 
  end
  
end
