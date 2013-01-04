class BaseVpc
  def initialize(cidr, number_public_subnets, number_private_subnets)
    @cidr = cidr
    @number_public_subnets = number_public_subnets
    @number_private_subnets = number_private_subnets
    setup()    
  end
  
  def generate
  end
    
  def setup
    define_subnets()
  end
  
  def define_subnets
    @ip_part = @cidr.split("/")[0].split(".")
    @bit_part = @cidr.split("/")[1].to_i
    @free_addresses = 2 ** @bit_part
    puts "free adresses = #{@free_addresses} (2^#{@bit_part})"
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

b = BaseVpc.new("192.168.0.0/16", 2, 1)
puts b.ip2num("192.168.0.0")

