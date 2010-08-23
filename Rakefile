require "rubygems"
require "rake"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec
task :default => :spec

begin
  require "hanna/rdoctask"

  Rake::RDocTask.new do |t|
    t.title = "Snippr - File based content management"
    t.rdoc_dir = "doc"
    t.rdoc_files.include("**/*.rdoc").include("lib/**/*.rb")
    t.options << "--line-numbers"
    t.options << "--webcvs=http://github.com/blaulabs/snippr/tree/master/"
  end
rescue LoadError
  puts "'gem install hanna' to generate documentation"
end
