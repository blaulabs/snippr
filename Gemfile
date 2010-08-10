#############################################################################
# Dependencies in this Gemfile are managed through the gemspec.  Add/remove
# depenencies there, rather than editing this file ex:
#
#   Gem::Specification.new do |s|
#     ... 
#     s.add_dependency("sinatra")
#     s.add_development_dependency("rack-test")
#   end
#
#############################################################################

source "http://gems.blau.de"
source "http://rubygems.org"

project_dir = File.expand_path('..', __FILE__)
gemspec_path = File.expand_path('snippr.gemspec', project_dir)

#
# Setup gemspec dependencies
#

gemspec = eval(File.read(gemspec_path))
gemspec.dependencies.each do |dep|
  group = dep.type == :development ? :development : :default
  gem dep.name, dep.requirement, :group => group
end
