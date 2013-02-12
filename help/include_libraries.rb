#puts "include libraries"
dirs = ["*/*.rb"]
dirs.each() {|dir|
  Dir[dir].each {|file|
    unless file.include?("main_") || file.include?("include_libraries.rb") || file.include?("examples") || file.include?("hidden_templates") 
      #puts "requires #{file}"
      require file
    end 
  }  
}

require 'aws'
require 'logger'
require 'yaml'
require 'axlsx' 
require 'nokogiri'
require 'open-uri'    


