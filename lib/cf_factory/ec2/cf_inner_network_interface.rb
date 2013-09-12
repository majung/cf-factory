require 'cf_factory/base/cf_inner'

module CfFactory
class CfInnerNetworkInterface
  include CfInner
    
  def additional_indent
    2
  end  

  def initialize(network_interface, device_index, options = {})
    @network_interface = network_interface
    @device_index = device_index
    @delete_on_termination = options[:delete_on_termination]
  end
    
  def get_cf_attributes
    result = {}
    result["NetworkInterfaceId"] = @network_interface.generate_ref
    result["DeviceIndex"] = @device_index
    result["DeleteOnTermination"] = @delete_on_termination unless @delete_on_termination.nil? 
    result
  end
  
end
end
