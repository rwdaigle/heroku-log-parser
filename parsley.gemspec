$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'parsley/version'

Gem::Specification.new do |s|
  s.name              = "parsley"
  s.version           = Parsley::VERSION
  s.platform          = Gem::Platform::RUBY
  s.author            = "Ryan Daigle"
  s.email             = ["ryan.daigle@gmail.com"]
  s.homepage          = "https://github.com/rwdaigle/parsley"
  s.summary           = "Syslog message parser"
  s.description       = "Easily parse Syslog formatted message strings"

  s.rubyforge_project = "parsley"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if File.exists?('UPGRADING')
    s.post_install_message = File.read("UPGRADING")
  end

  s.required_ruby_version = ">= 1.8.7"

  # s.add_dependency('activerecord', '>= 3.0.0')
  # s.add_dependency('activemodel', '>= 3.0.0')
  # s.add_dependency('activesupport', '>= 3.0.0')
  # s.add_dependency('cocaine', '~> 0.4.0')
  # s.add_dependency('mime-types')

  # s.add_development_dependency('shoulda')
  # s.add_development_dependency('appraisal')
  # s.add_development_dependency('mocha')
  # s.add_development_dependency('aws-sdk', '>= 1.2.0')
  # s.add_development_dependency('bourne')
  # s.add_development_dependency('sqlite3', '~> 1.3.4')
  # s.add_development_dependency('cucumber', '~> 1.2.1')
  # s.add_development_dependency('aruba')
  # s.add_development_dependency('nokogiri')
  # s.add_development_dependency('capybara')
  # s.add_development_dependency('bundler')
  # s.add_development_dependency('cocaine', '~> 0.2')
  # s.add_development_dependency('fog', '>= 1.4.0', "< 1.7.0")
  # s.add_development_dependency('pry')
  # s.add_development_dependency('launchy')
  # s.add_development_dependency('rake')
  # s.add_development_dependency('fakeweb')
  # s.add_development_dependency('railties')
  # s.add_development_dependency('actionmailer')
end