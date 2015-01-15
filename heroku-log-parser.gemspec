$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'heroku-log-parser/version'

Gem::Specification.new do |s|
  s.name              = "heroku-log-parser"
  s.version           = HerokuLogParser::VERSION
  s.platform          = Gem::Platform::RUBY
  s.author            = "Ryan Daigle"
  s.email             = ["ryan.daigle@gmail.com"]
  s.homepage          = "https://github.com/rwdaigle/heroku-log-parser"
  s.summary           = "Syslog message parser"
  s.description       = "Easily parse Heroku's syslog-based application log-stream"

  s.rubyforge_project = "heroku-log-parser"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.8.7"

  s.add_development_dependency 'rspec'
end
