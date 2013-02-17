Gem::Specification.new do |s|
  s.name        = 'cf_factory'
  s.version     = '0.0.2'
  s.summary     = "CloudFormation template generator"
  s.description = "Cf-factory is a Ruby library to generate CloudFormation templates."
  s.authors     = ["majung","cgorski"]
  s.email       = ["majung@amazon.com","cgorski@amazon.com"]
  s.files       = Dir['lib/**/*.rb', 'examples/**/*.rb']
  s.homepage    = 'https://github.com/majung/cf-factory'
end
