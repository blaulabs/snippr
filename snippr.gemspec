# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "snippr"
  s.version     = "0.6.0"
  s.date        = Time.now
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Jachmann"]
  s.email       = ["me@rubiii.com"]
  s.homepage    = "http://github.com/blaulabs/snippr"
  s.summary     = %q{File based content management}
  s.description = %q{This gem provides ways to access file based cms resources from a rails app.}

  s.rubyforge_project = "snippr"

  s.add_runtime_dependency "i18n"
  s.add_runtime_dependency "activesupport"

  s.add_development_dependency "ci_reporter", "~> 1.6.3"
  s.add_development_dependency "rspec", "~> 2.0.0"
  s.add_development_dependency "mocha", "0.9.8"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.rdoc_options += ["--title", "Snippr - File based content management"]
end
