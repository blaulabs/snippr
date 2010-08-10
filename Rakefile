require "rubygems"
require "rake"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new :spec
task :default => :spec

task :bundle_install do
  puts `bundle install`
end

desc "Tag gem"
task :tag do
  project_dir = File.expand_path('..', __FILE__)
  gemspec_path = File.expand_path('snippr.gemspec', project_dir)
  gemspec = eval(File.read(gemspec_path))
  version = "v#{gemspec.version}"
  puts `git push && git tag -am "#{version}" #{version} && git push --tags`
end

desc "Build gem and publish to gem server"
task :build_and_publish => %w(bundle_install spec) do
  if `gem build snippr.gemspec` =~ /File: (snippr-[0-9.]+\.gem)$/mi
    # TODO git tagging? [thomas, 2010-07-20]
    puts `gem push_to_blau #{$1}`
  end
end

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
