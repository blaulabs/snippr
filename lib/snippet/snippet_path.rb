# = SnippetPath
#
# This module is included into the Snippet component for retrieving and setting
# the path to the snippet files.
module SnippetPath

  # The snippet path JVM property.
  SnippetPathProperty = "cms.snippet.path"

  # Returns the snippet path from JVM properties.
  def snippet_path
    path = JavaLang::System.get_property(SnippetPathProperty) rescue @snippet_path
    validate_snippet_path path
  end

  # Sets the snippet path as a JVM property.
  def snippet_path=(path)
    validate_snippet_path path
    JavaLang::System.set_property(SnippetPathProperty, path) if jruby?
    @snippet_path = path
  end

private

  # Validates a given snippet +path+. Raises an ArgumentError in case of an
  # invalid snippet path or just returns the original path.
  def validate_snippet_path(path = nil)
    raise ArgumentError, "Missing snippet path!" unless path
    raise ArgumentError, "Invalid snippet_path: #{path}" unless File.directory? path
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