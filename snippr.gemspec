# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "snippr"
  s.version     = '0.17.0'
  s.date        = Time.now
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Harrington", "Thomas Jachmann", "Frank Schumacher"]
  s.email       = ["me@rubiii.com", "self@thomasjachmann.com", "frank.schumacher.privat@gmail.com"]
  s.homepage    = "http://github.com/blaulabs/snippr"
  s.summary     = %q{File based content management}
  s.license     = "MIT"
  s.description = %q{This gem provides ways to access file based cms resources from a rails app.}

  s.rubyforge_project = "snippr"

  s.add_runtime_dependency "i18n"
  s.add_runtime_dependency "activesupport"

  s.add_development_dependency "ci_reporter", "~> 1.6.5"
  s.add_development_dependency "rspec", "~> 2.14.0"
  s.add_development_dependency "rake", "~> 10.0"

  unless ENV["CI"]
    s.add_development_dependency "pry-debugger"
  end

  s.files         = `git ls-files`.split("\n").reject{ |a| a.start_with?("\"") }
  s.test_files    = `git ls-files -- spec/*`.split("\n").reject{ |a| a.start_with?("\"") }
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
