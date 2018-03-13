# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_headers_logger/version'

Gem::Specification.new do |gem|
  gem.name          = 'request_headers_logger'
  gem.version       = RequestHeadersLogger::VERSION
  gem.authors       = ['Al-waleed Shihadeh']
  gem.email         = ['wshihadh@gmail.com']
  gem.description   = 'RequestHeaderLogger Allows you to tag logs with RequestHeader flags.'
  gem.summary       = 'RequestHeaderLogger Allows you to tag logs with RequestHeader flags.'
  gem.homepage      = 'https://github.com/wshihadeh/request_headers_logger'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '> 4.0'
  gem.add_dependency 'request_headers_middleware', '~> 0.0.4'

  gem.add_development_dependency 'delayed_job', '~> 4.1', '>= 4.1.4'
  gem.add_development_dependency 'rack', '~> 1.6', '>= 1.6.5'
  gem.add_development_dependency 'rake', '~> 12.0', '>= 12.0.0'
  gem.add_development_dependency 'rspec', '~> 3.5', '>= 3.5.0'
  gem.add_development_dependency 'rubocop', '~> 0.53.0'
  gem.add_development_dependency 'simplecov', '~> 0.12.0'
end
