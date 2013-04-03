Gem::Specification.new do |s|
  s.name        = 'cf_factory'
  s.version     = '0.0.5'
  s.summary     = "CloudFormation template generator"
  s.description = "Cf-factory is a Ruby library to generate CloudFormation templates."
  s.authors     = ["majung","cgorski"]
  s.email       = ["majung@amazon.com","cgorski@amazon.com"]
  s.files       = Dir['lib/**/*.rb', 'examples/**/*.rb', 'bin/**/*.rb']
  s.executables = ['cf_factory']
  s.homepage    = 'https://github.com/cgorski/cf-factory'
  s.required_ruby_version = '>= 1.9.3'
  s.add_dependency('require_all','>=1.2.1')
  s.add_dependency('rubyzip','>=0.9.9')
  s.add_dependency('aws-sdk','>=1.8.5') 
end
