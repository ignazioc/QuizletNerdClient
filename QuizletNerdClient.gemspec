# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'QuizletNerdClient/version'

Gem::Specification.new do |spec|
  spec.name          = 'QuizletNerdClient'
  spec.version       = QuizletNerdClient::VERSION
  spec.authors       = ['Calò, Ignazio']
  spec.email         = ['ignazioc@gmail.com']

  spec.summary       = 'This is an unofficial, unsupported command line client for Quizlet.com'
  spec.description   = 'This is an unofficial, unsupported command line client for Quizlet.com'
  spec.homepage      = 'https://github.com/ignazioc/QuizletNerdClient'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'commander'
  spec.add_dependency 'oauth2'
  spec.add_dependency 'oauth2-client'
  spec.add_dependency 'launchy'
  spec.add_dependency 'highline'
  spec.add_dependency 'terminal-table'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
