lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require '3scale/api/version'

Gem::Specification.new do |spec|
  spec.name          = '3scale-api'
  spec.version       = ThreeScale::API::VERSION
  spec.authors       = ['Miguel Soriano', 'Eguzki Astiz Lezaun']
  spec.email         = ['msoriano@redhat.com', 'eastizle@redhat.com']

  spec.summary       = 'API Client for 3scale APIs'
  spec.description   = 'API Client to access your 3scale APIs: Account Management API'
  spec.homepage      = 'https://github.com/3scale/3scale-api-ruby'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib,exe}/**/*.rb'] + %w[README.md]
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'webmock', '~> 3.4'
end
