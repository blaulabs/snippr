# = SnipprPath
#
# This module is included into the Snippr component for retrieving and setting
# the path to the snippr files.
module SnipprPath

  # The snippr path JVM property.
  JVMProperty = "cms.snippet.path"

  # Returns the snippr path from JVM properties.
  def path
    JavaLang::System.get_property(JVMProperty) rescue @path
  end

  # Sets the snippr path as a JVM property.
  def path=(path)
    path = path.to_s
    raise ArgumentError, "Invalid path: #{path}" unless File.directory? path
    JavaLang::System.set_property(JVMProperty, path) if jruby?
    @path = path
  end

private

  # Returns whether the current Ruby platform is JRuby.
  def jruby?
    RUBY_PLATFORM =~ /java/
  end

  module_function :jruby?

  if jruby?
    module JavaLang
      include_package "java.lang"
    end
  end

end