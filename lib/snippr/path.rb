# = Snippr::Path
#
# Provides methods for dealing with the path to snippr files.
module Snippr
  module Path

    # The JVM property to set the path to the snippr files.
    JVM_PROPERTY = 'cms.snippet.path'

    # Returns the path to the snippr files (from JVM properties if available).
    def self.path
      @@path ||= JavaLang::System.get_property(JVM_PROPERTY) rescue ""
    end

    # Sets the path to the snippr files.
    def self.path=(path)
      @@path = path.to_s
    end

    # Builds a snippr name from an array of path parts.
    def self.normalize_name(*names)
      names.map do |name|
        name.kind_of?(Symbol) ? name.to_s.camelize(:lower) : name
      end.join("/")
    end

    # Builds a snippr path (inside the configured path) from a name and an optional extension.
    def self.path_from_name(name, ext = nil)
      File.join(path, (ext ? "#{name}.#{ext}" : name))
    end

    # Lists all snips inside a snippr directory specified by path parts.
    def self.list(*names)
      dir = path_from_name normalize_name *names
      Dir["#{dir}/*#{I18n.locale}.#{Snip::FILE_EXTENSION}"].map do |snip|
        snip.gsub(/^.*\/([^\.]+)?\.#{Snip::FILE_EXTENSION}$/, '\1').gsub(/_.*$/, '').underscore
      end.sort.map(&:to_sym)
    end

  private

    if RUBY_PLATFORM =~ /java/
      require 'java'
      module JavaLang
        include_package "java.lang"
      end
    end

  end
end
