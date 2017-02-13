# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require '3scale/api/version'

Gem::Specification.new do |spec|
  spec.name          = '3scale-api'
  spec.version       = ThreeScale::API::VERSION
  spec.authors       = ['Michal Cichra']
  spec.email         = ['michal@3scale.net']

  spec.summary       = 'API Client for 3scale APIs'
  spec.description   = 'API Client to access your 3scale APIs: Account Management API'
  spec.homepage      = 'https://github.com/3scale/3scale-api-ruby.'
  spec.license       = "MIT"

  spec.files         = Dir['{lib,exe}/**/*.rb'] + %w(README.md)
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'webmock', '~> 2.3.2'
end
