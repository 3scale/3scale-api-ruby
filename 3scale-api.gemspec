# coding: utf-8

require_relative 'lib/3scale/api/version'

Gem::Specification.new do |spec|
  spec.name          = '3scale-api'
  spec.version       = ThreeScale::API::VERSION
  spec.authors       = ['Michal Cichra', 'Eguzki Astiz Lezaun']
  spec.email         = %w(michal@3scale.net eastizle@redhat.com)

  spec.summary       = 'API Client for 3scale APIs'
  spec.description   = 'API Client to access your 3scale APIs: Account Management API'
  spec.homepage      = 'https://github.com/3scale/3scale-api-ruby'
  spec.license       = "MIT"

  spec.files         = Dir['{lib,exe}/**/*.rb'] + %w(README.md)
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'webmock', '~> 3.4'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'dotenv', '~> 2.7'
  spec.add_development_dependency 'pry-byebug', '~> 3.7' if RUBY_PLATFORM == 'ruby'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'fakefs', '>= 0.8.1'
end
