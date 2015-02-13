$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bootstrap3_form_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bootstrap3_form_builder"
  s.version     = Bootstrap3FormBuilder::VERSION
  s.authors     = ["Zachary Wright"]
  s.email       = ["zacharygwright@gmail.com"]
  s.homepage    = "https://github.com/zacharyw/bootstrap3-form-builder"
  s.summary     = "Builds forms with Twitter Bootstrap 3 styling."
  s.description = "Custom form builder to create forms and inputs that work with Bootstrap 3. Also automatically sets pattern and required HTML5 attributes based on validators on domain objects."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-rails')

  #Used for generator testing
  s.add_development_dependency('ammeter') 
end
