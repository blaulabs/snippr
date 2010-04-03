# = SnippetPath
#
# This module is included into the Snippet component for retrieving and setting
# the path to the snippet files.
module SnippetPath

  # The snippet path JVM property.
  SnippetPathProperty = "cms.snippet.path"

  # Returns the snippet path from JVM properties.
  def snippet_path
    path = JavaLang::System.get_property SnippetPathProperty
    invalid_snippet_path(path) unless path && File.directory?(path)
    path
  end

  # Sets the snippet path as a JVM property.
  def snippet_path=(path)
    invalid_snippet_path(path) unless File.directory? path
    JavaLang::System.set_property SnippetPathProperty, path
  end

private

  # Raises an ArgumentError complaining about an invalid snippet path.
  def invalid_snippet_path(path = nil)
    raise ArgumentError, "Invalid snippet_path: '#{path}'"
  end

  # Contains the java.lang package.
  module JavaLang
    include_package "java.lang"
  end

end