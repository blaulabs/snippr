Gem::Specification.new do |s|
  s.name = "snippr"
  s.version = "0.1.1"
  s.date = "2010-04-30"

  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/blaulabs/snippr"
  s.summary = "File based content management"

  s.files = Dir["[A-Z]*", "{lib,spec}/**/*.{rb,snip}"]
  s.test_files = Dir["spec/**/*.rb"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.rdoc_options += ["--title", "Snippr - File based content management"]

  s.add_development_dependency "rspec", ">= 1.2.8"
end