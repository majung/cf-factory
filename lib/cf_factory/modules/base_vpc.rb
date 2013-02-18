module CfFactory
class BaseVpc
  attr_reader :vpc, :subnets, :private_route_table, :public_route_table
  
  def initialize(name, cidr, number_public_subnets, number_private_subnets, availability_zones, subnet_size = 256)
    @name = name
    @cidr = cidr
    @number_public_subnets = number_public_subnets
    @number_private_subnets = number_private_subnets
    @subnet_size = subnet_size  
    @availability_zones = availability_zones
    setup()    
  end
  
  def add_to_template(cf)
    cf.add_vpc(@vpc)
  end
    
  def setup
    define_vpc()
    define_subnets()
  end
  
  def define_vpc
    @vpc = CfVpc.new(@cidr)
    igw = CfInternetGateway.new("#{@name}Igw", @vpc)
    @vpc.add_internet_gateway(igw)
    @private_route_table = CfRouteTable.new("#{@name}PrivRt")
    @vpc.add_route_table(@private_route_table)
    @public_route_table = CfRouteTable.new("#{@name}PubRt")
    igw_route = CfRoute.new("IgwRoute", "0.0.0.0/0", igw)
    @public_route_table.add_route(igw_route)
    @vpc.add_route_table(@public_route_table)
  end
  
  def define_subnets
    myMask = IpMask.create_from_cidr(@cidr)
    puts "myMask = #{myMask.inspect}"
    divider_array = [@subnet_size]*(@number_public_subnets + @number_private_subnets)
    puts "divider_array = #{divider_array}"
    subnet_ranges = myMask.divide_individually(divider_array)
    puts "subnet ranges = #{subnet_ranges.inspect}"
    @subnets = []
    0.upto(@number_public_subnets-1) do |i| 
      @vpc.add_subnet(CfSubnet.new("#{@name}PublicSubnet#{i+1}", @cidr, @availability_zones[i%(@availability_zones.size)], @public_route_table))  
    end
    0.upto(@number_private_subnets-1) do |i| 
      @vpc.add_subnet(CfSubnet.new("#{@name}PrivateSubnet#{i+1}", @cidr, @availability_zones[i%(@availability_zones.size)], @private_route_table))  
    end    
  end
  
  def ip2num(ip_part)
    sum = 0
    exp = 3
    ip_part.split(".").each() {|ip|
      sum += ip.to_i * (256 ** exp)
      exp -= 1
    }
    sum
  end
    
end
end
