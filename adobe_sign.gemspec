$:.push File.expand_path('../lib', __FILE__)

require 'adobe_sign/version'

Gem::Specification.new do |s|
  s.name        = 'adobe_sign'
  s.version     = AdobeSign::Version::STRING
  s.authors     = ['Luiz Nascimento']
  s.summary     = 'Summary of Adobe Sign.'
  s.description = "A ruby gem that simplifies the use of Adobe's EchoSign web API."

  s.files = `git ls-files`.split('n')
  s.require_path = 'lib'

  s.add_dependency 'json'
  s.add_dependency 'rack'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday-multipart'
  s.add_dependency 'marcel'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'minitest-reporters'

  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'pry'
end
