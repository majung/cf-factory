require 'aws'

class IpMask
  attr_reader :bits, :ip_mask 
  
  def initialize(ip_mask, bits = 32) #if one parameter specified, means it's not a range, it's one address
    @ip_mask = ip_mask
    @bits = bits
  end
  
  def self.create(ip_mask, bits = 32)
    cleaned = IpMask.new(ip_mask, bits)
    cleaned.clean_mask()
  end
  
  def self.create_from_cidr(cidr)
    ip  = cidr.split("/")[0].split(".")
    bits  = cidr.split("/")[1].to_i    
  end
  
  def self.create_from_num(number, bits)
    ip_bytes = []
    3.downto(0) {|i|
      div = 256 ** i
      b = number/div.to_i
      ip_bytes << b.to_i
      number = number % div
    }
    ip_bytes
    IpMask.new(ip_bytes.join("."), bits)
  end
  
  def to_num
    sum = 0
    exp = 3
    @ip_mask.split(".").each() {|ip|
      sum += ip.to_i * (256 ** exp)
      exp -= 1
    }
    sum
  end

  def to_mask
    bit_string = self.to_bit_string 
    r = bit_string.to_i(2)
  end
  
  def to_bit_string    
    bit_string = ("1"*@bits+"0"*(32-@bits))
    #puts "#{bit_string}"
    bit_string
  end
  
  def free()
    (2 ** 32) / used()
  end
  
  def used()
    2 ** @bits 
  end
  
  def generate_free()
    self.to_num()
  end
    
  def to_s
    if @bits.to_i == 32
      "#{@ip_mask}"
    else
      "#{@ip_mask}/#{@bits}"
    end
  end
    
  def clean_mask
    ip_base_num = self.to_num
    ip_bits_num = self.to_mask()
    clean_mask = ip_base_num & ip_bits_num
    #puts "clean_mask = #{clean_mask}"
    IpMask.create_from_num(clean_mask,@bits)
  end
  
  def is_clean?
    comp = self.clean_mask
    return self.ip_mask != comp.ip_mask
  end
  
  def divide(number_of_addresses)
    bits_to_move = (Math.log(number_of_addresses+1)/Math.log(2)).to_i
    puts "asked to allocate #{number_of_addresses}; that corresponds to #{bits_to_move} bits"
    puts "#{self.free()} are free"
    max_subnets = self.free()/number_of_addresses
    puts "given that every subnet should have #{number_of_addresses} addresses, there is currently space for #{max_subnets}"
    0.upto(max_subnets-1) {|i|
      num = self.to_num()
      num += i*number_of_addresses
      possible_range = IpMask.create_from_num(num, 32 - bits_to_move)
      puts "possible range: #{possible_range}"
    }
  end  
      
  def divide_individually(array_with_number_of_addresses)
    possible_ranges = []
    num = self.to_num()
    bits_to_move = 32 - @bits
    remaining_addresses = self.free
    array_with_number_of_addresses.each() {|number_of_addresses_for_subnet|
      if (2 ** bits_to_move) < number_of_addresses_for_subnet
        puts "WARNING: could not allocate #{number_of_addresses_for_subnet} anymore (max #{(2 ** bits_to_move)})"
        next
      end        
      bits_to_move = [(Math.log(number_of_addresses_for_subnet+1)/Math.log(2)).to_i, bits_to_move].min      
      possible_range = IpMask.create_from_num(num, 32 - bits_to_move)
      unless self.are_all_in_range?(possible_range)
        puts "WARNING: the selected range '#{possible_range}' is outside the base range"
        next
      end
      num += number_of_addresses_for_subnet
      puts "[alloc #{number_of_addresses_for_subnet}] \tpossible range: #{possible_range}"
      possible_ranges << possible_range
      remaining_addresses -= (2 ** bits_to_move)
      #puts "[to allocate = #{number_of_addresses_for_subnet}] => free = #{possible_range.free}"
    }
    possible_ranges
  end
  
  def is_in_range?(ip_address)
    comp_mask = IpMask.new(ip_address)
    # transform ip address string to numerical values for bitwise operations
    comp_ip = comp_mask.to_num
    #puts "ip_address checked = #{comp_ip.to_s(2)}"
    ip_base_num = self.to_num
    #puts "range_mask         = #{ip_base_num.to_s(2)}"
    ip_bits_num = self.to_mask
    #puts "bit_mask           = #{ip_bits_num.to_s(2)}"
    # perform an AND operation to get rid of the bits in the mask that don't count
    clean_mask = ip_base_num & ip_bits_num
    #puts "cleaned range_mask = #{ip_base_num.to_s(2)}"
    # the ip address belongs to the range, when an AND with the bitmask equals the cleaned mask
    #puts "(ip_address&bits   = #{(comp_ip & ip_bits_num).to_s(2)}"
    (comp_ip & ip_bits_num) == clean_mask
  end
   
  def are_all_in_range?(ip_mask)
    #puts "check for #{ip_mask}"
    return false if ip_mask.bits < self.bits
    #
    comp_ip = ip_mask.to_num
    ip_base_num = self.to_num
    ip_bits_num = self.to_mask
    ip_clean = ip_base_num & ip_bits_num
    #puts "comp = #{(comp_ip & ip_bits_num)} ip_clean = #{ip_clean} (ip_bits_num = #{ip_bits_num})"
    (comp_ip & ip_bits_num) == ip_clean
  end
   
  def ==(comp)
    puts "comp = #{comp.class} #{comp.inspect}"
    self.ip_mask == comp.ip_mask && self.bits == comp.bits
  end
    
end

ip = IpMask.create("192.168.0.18",16)
ip = IpMask.create("10.0.0.0",16)
puts "ip = #{ip.to_s}"

number = ip.to_num
new_ip = IpMask.create_from_num(number,24)
#puts "test create from number: #{new_ip}"

puts ip.to_s
puts "free = #{ip.free}"
puts "used = #{ip.used}"
puts "mask: #{ip.to_mask}"

#puts "divide #{ip.divide(256)}"
address_size_array = [256,256,256,256]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [512,256,256]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [256,512,256]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [256,128,128,128,128,128,128,128,128,256,128,128]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [512,256,128,64,32,16,8]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [512,256,128,64,32,16,8,16,32,64,128,256,512]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [1024,512,256,128,256,512, 1024, 1024]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [16,32,64,128,256,512]
puts "== divide #{ip.divide_individually(address_size_array)}"
address_size_array = [256]*257
puts "== divide #{ip.divide_individually(address_size_array)}"

