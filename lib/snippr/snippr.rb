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
    MissingSnipprComment = "<!-- missing snippr: %s -->"


    # Expects the name of a snippr file. Also accepts a Hash of placeholders
    # to be replaced with dynamic values.
    def load(*args)
      dynamics = args.last.kind_of?(Hash) ? args.pop : {}
      # load snippr
      name = snippr_name(args) + locale
      snippr = snippr_content(name, dynamics).strip
      # determine whether the content is missing or empty
      missing = snippr == MissingSnipprComment
      empty = missing || snippr.empty?
      # fill comments with name
      snippr = missing ? snippr % name : SnipprComments % [name, snippr, name]
      # add dynamically generated methods and return
      snippr.instance_eval %(def missing_snippr?; #{missing}; end)
      snippr.instance_eval %(def empty_snippr?; #{empty}; end)
      snippr
    end

    # Expects the name of a snippr directory.
    def list(*args)
      dir = snippr_path snippr_name args
      Dir["#{dir}/*#{locale}.snip"].map do |snip|
        snip.gsub(/^.*\/([^\.]+)?\.snip$/, '\1').gsub(/_.*$/, '').underscore.to_sym
      end
    end

  private

    # Returns the name of a snippr from a given Array of +args+.
    def snippr_name(args)
      args.map { |arg| arg.kind_of?(Symbol) ? arg.to_s.camelize(:lower) : arg }.join("/")
    end

    # Returns the raw snippr content or a +MissingSnipprComment+ in case the snippr
    # file does not seem to exist.
    def snippr_content(name, dynamics)
      file = snippr_path name, FileExtension
      return MissingSnipprComment unless File.exist? file
      
      content = File.read(file).strip
      dynamics.each { |placeholder, value| content.gsub! "{#{placeholder}}", value.to_s }
      linkify content
    end

    # Returns the complete path to a snippr file.
    def snippr_path(name, ext = nil)
      File.join path, "#{name}#{ext}"
    end

  end
end
