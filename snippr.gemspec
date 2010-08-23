require "date"
require "bundler"

Gem::Specification.new do |s|
  now = Time.now

  s.name = "snippr"
  s.version = "0.4.#{now.strftime('%Y%m%d%H%M%S')}"
  s.date = now

  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/blaulabs/snippr"
  s.summary = "File based content management"

  s.files = Dir["[A-Z]*", "{lib,rails,spec}/**/*.{rb,snip}"]
  s.test_files = Dir["spec/**/*.rb"]

  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source"]
  s.rdoc_options += ["--title", "Snippr - File based content management"]

  Bundler::Definition.build('Gemfile', 'Gemfile.lock', false).dependencies.each do |dep|
    if dep.groups.any? {|group| [:default, :production].include? group}
      s.add_runtime_dependency dep.name, *dep.requirements_list
    else
      s.add_development_dependency dep.name, *dep.requirements_list
    end
  end
end
