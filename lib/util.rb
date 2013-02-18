#!/usr/bin/ruby

Dir["**/*.rb"].each do |file|
  contents = open(file) { |f| f.read }
  matched = false
  open(file, "w") do |f| 
    contents.each_line do |line|
      if (not matched) && (line.match /^class/) 
        f.puts "module CfFactory"
        f.puts "#{line}"
        matched = true
      else
        f.puts "#{line}"
      end
    end
  f.puts "end"
  end
end

end
