require_relative "lib/authentication/version"

Gem::Specification.new do |spec|
  spec.name        = "authentication"
  spec.version     = Authentication::VERSION
  spec.authors     = [ "Jane-Terziev" ]
  spec.email       = [ "janeterziev@gmail.com" ]
  spec.summary     = "Authentication engine"
  spec.description = "Authentication engine."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", ">= 8.0.0.rc1"
  spec.add_dependency "devise"
  spec.add_dependency "importmap-rails"
  spec.add_development_dependency 'rspec-rails'
end
