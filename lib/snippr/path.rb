# # -*- encoding : utf-8 -*-
# = Snippr::Path
#
# Provides methods for dealing with the path to snippr files.
module Snippr
  module Path

    # Returns the path to the snippr files
    def self.path
      if @@path.respond_to?(:call)
        @@path_evaled ||= @@path.call
      else
        @@path.to_s
      end
    end

    # Sets the path to the snippr files.
    def self.path=(path)
      @@path = path
    end

    # Builds a snippr name from an array of path parts.
    def self.normalize_name(*names)
      names.map do |name|
        Normalizer.normalize(name)
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

  end
end
