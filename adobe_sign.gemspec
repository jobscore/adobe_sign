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
  s.add_dependency 'httparty'
end
