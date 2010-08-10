require "snippr/core_ext"
require "snippr/path"
require "snippr/i18n"
require "snippr/link"

# = Snippr
# ==== File based content management
#
# A snippr file is a piece of HTML or raw text to be included in a website. They are plain text
# files stored on the file system. Snippr files end with ".snip" and are read from the Snippr path.
module Snippr
  extend Snippr::Path
  extend Snippr::I18n
  extend Snippr::Link

  class << self

    # The snippr file extension.
    FileExtension = ".snip"

    # The comments wrapping a snippr.
    SnipprComments = "<!-- starting snippr: %s -->\n%s\n<!-- closing snippr: %s -->"

    # The fallback tag for a missing snippr.
    MissingSnipprTag = '<samp class="missing snippr" />'


    # Expects the name of a snippr file. Also accepts a Hash of placeholders
    # to be replaced with dynamic values.
    def load(*args)
      @dynamics = args.last.kind_of?(Hash) ? args.pop : {}
      @name = name_from args
      snippr = content
      missing = snippr == MissingSnipprTag
      snippr = SnipprComments % [@name, snippr, @name]
      snippr.instance_eval %(def missing_snippr?; #{missing}; end)
      snippr
    end

  private

    # Returns the name of a snippr from a given Array of +args+.
    def name_from(args)
      args.map { |arg| arg.kind_of?(Symbol) ? arg.to_s.lower_camelcase : arg }.join("/") + locale
    end

    # Returns the raw snippr content or a +MissingSnipprTag+ in case the snippr
    # file does not seem to exist.
    def content
      return MissingSnipprTag unless File.exist? file
      
      content = File.read(file).strip
      insert_dynamics content
      linkify content
    end

    # Returns the complete path to a snippr file.
    def file
      File.join path, [@name, FileExtension].join
    end

    # Replaces placeholders found in a given snippr +content+ with dynamic values.
    def insert_dynamics(content)
      @dynamics.each { |placeholder, value| content.gsub! "{#{placeholder}}", value.to_s }
    end

  end
end
