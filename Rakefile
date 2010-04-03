require "rake"
require "spec/rake/spectask"
require "spec/rake/verify_rcov"

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.rcov = true
  t.rcov_opts = %w(--exclude-only ^\/User,spec\/)
end

namespace :spec do
  RCov::VerifyTask.new(:rcov => :spec) do |t|
    t.threshold = 90
    t.index_html = "coverage/index.html"
  end
end

begin
  require "hanna/rdoctask"

  Rake::RDocTask.new do |t|
    t.title = "Snippet - File based content management"
    t.rdoc_dir = "doc"
    t.rdoc_files.include("**/*.rdoc").include("lib/**/*.rb")
    t.options << "--line-numbers"
    t.options << "--webcvs=http://github.com/rubiii/snippet/tree/master/"
  end
rescue LoadError
  puts "'gem install hanna' for documentation"
end