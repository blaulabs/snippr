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

gemspec_path = Dir[File.expand_path('../*.gemspec', __FILE__)].first
gemspec = eval(File.read(gemspec_path))

#
# Setup gemspec dependencies
#

gemspec.dependencies.each do |dep|
  group = dep.type == :development ? :development : :default
  name = dep.name
  if dep.name == 'activesupport'
    gem dep.name, dep.requirement, :group => group, :require => 'active_support'
  else
    gem dep.name, dep.requirement, :group => group
  end
end
