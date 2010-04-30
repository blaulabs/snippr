# = SnipprPath
#
# This module is included into the Snippr component for retrieving and setting
# the path to the snippr files.
module SnipprPath

  # The snippr path JVM property.
  JVMProperty = "cms.snippet.path"

  # Returns the snippr path from JVM properties.
  def path
    path = JavaLang::System.get_property(JVMProperty) rescue @path
    validate_path path
  end

  # Sets the snippr path as a JVM property.
  def path=(path)
    validate_path path.to_s
    JavaLang::System.set_property(JVMProperty, path) if jruby?
    @path = path
  end

  # Returns the base path.
  def base_path
    @base_path || ""
  end

  # Sets the base path.
  def base_path=(base_path)
    @base_path = base_path
  end

private

  # Validates a given snippr +path+. Raises an ArgumentError in case of an
  # invalid snippr path or just returns the original path.
  def validate_path(path = nil)
    raise ArgumentError, "Missing snippr path!" unless path
    raise ArgumentError, "Invalid path: #{path}" unless File.directory? path
    path
  end

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