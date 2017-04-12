basedir = File.expand_path(File.dirname(__FILE__))
require "#{basedir}/lib/vsts/version"

Gem::Specification.new do |s|
  s.name        = 'ruby_vsts'
  s.version     = VSTS::VERSION
  s.summary     = 'An unofficial Microsoft Visual Studio Team Services (VSTS) API client in Ruby'
  s.description = <<-ENDOFDESC
    An API client to the Microsoft Visual Studio online Rest APIs. It can connect to VSTS via the public API
    and query VSTS with a personal access token. May also work with TFS.
  ENDOFDESC
  s.author      = 'Gabor Lengyel'
  s.email       = 'ruby_vsts@prodexity.com'
  s.files       = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage    = 'https://github.com/prodexity/ruby_vsts/'
  s.license     = 'MIT'

  # s.test_files = s.files.grep(%r{^(test|spec|features)/})
  # s.require_paths = %w(lib)

  s.add_runtime_dependency 'rest-client'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-json'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'yard'

  s.cert_chain  = ['certs/ruby_vsts-gem-public_cert.pem']
  s.signing_key = File.expand_path("~/.ssh/ruby_vsts-gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")
end

