# -*- encoding: utf-8 -*-

require File.expand_path('../lib/pandora/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'pandora_client'
  gem.version       = Pandora::VERSION
  gem.author        = 'Gopal Patel'
  gem.email         = 'nixme@stillhope.com'
  gem.license       = 'MIT'
  gem.homepage      = 'https://github.com/nixme/pandora_client'
  gem.description   = 'A ruby wrapper for the Pandora Tuner JSON API'
  gem.summary       = 'A ruby wrapper for the Pandora Tuner JSON API'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # Dependencies
  gem.required_ruby_version = '>= 1.9.2'
  gem.add_runtime_dependency 'faraday', '~> 0.8'
  gem.add_runtime_dependency 'crypt19', '~> 1.2.1'
  gem.add_runtime_dependency 'nokogiri', '~> 1.5.2'
end
