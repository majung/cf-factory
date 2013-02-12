require 'cf_factory/base/cf_base'

class CfRouteTable
  include CfBase
    
  def initialize(name)
    @name = name
    @vpc = ":::::"
    @routes = []
  end
  
  def add_route(route)
    route.set_route_table(self)
    @routes << route
  end
  
  def set_vpc(vpc)
    @vpc = vpc
  end
  
  def get_cf_type
    "AWS::EC2::RouteTable"
  end
  
  def get_cf_attributes
    {}
  end
  
  def get_cf_properties
    {"VpcId" => @vpc.generate_ref}
  end  
  
  def generate
    super
    @routes.each() {|route|
      @result += route.generate
    } 
    @result
  end
  
end