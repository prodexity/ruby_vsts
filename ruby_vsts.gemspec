Gem::Specification.new do |s|
  s.name        = 'ruby_vsts'
  s.version     = '0.0.1'
  s.date        = '2017-04-07'
  s.summary     = 'A Microsoft Visual Studio Team Services (VSTS) API client in Ruby'
  s.description = <<-ENDOFDESC
    An API client to the Microsoft Visual Studio online Rest APIs. It can connect to VSTS via the public API
    and query VSTS with a pre-configured access token.

    API coverage is not full, focus is on changesets and individual changes in TFVC and Git.
  ENDOFDESC
  s.author      = 'Gabor Lengyel'
  s.email       = 'ruby_vsts@prodexity.com'
  s.files       = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage    = 'http://rubygems.org/gems/ruby_vsts'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rest-client'
  s.add_development_dependency 'minitest'
end
