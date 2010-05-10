require "rake"
require "spec/rake/spectask"

task :default => :spec

Spec::Rake::SpecTask.new

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
