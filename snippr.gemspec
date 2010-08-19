require "date"

Gem::Specification.new do |s|
  s.name = "snippr"
  s.version = "0.3.6"
  s.date = Date.today.to_s

  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/blaulabs/snippr"
  s.summary = "File based content management"

  s.files = Dir["[A-Z]*", "{lib,rails,spec}/**/*.{rb,snip}"]
  s.test_files = Dir["spec/**/*.rb"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.rdoc_options += ["--title", "Snippr - File based content management"]

  s.add_dependency "i18n"
  s.add_dependency "activesupport"
  s.add_development_dependency "rspec", ">=2.0.0.beta.19"
  s.add_development_dependency "mocha", "0.9.8"
end
