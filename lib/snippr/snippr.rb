require "snippr/core_ext"
require "snippr/path"
require "snippr/i18n"

# = Snippr
# ==== File based content management
#
# A snippr file is a piece of HTML or raw text to be included in a website. They are plain text
# files stored on the file system. Snippr files end with ".snip" and are read from the Snippr path.
#
# == Snippr path
#
# You need to specify the path to the directory where your Snippr files are stored:
#
#   Snippr.path = File.join File.dirname(__FILE__), "..", "snippr"
#
# When running on JRuby, you can also set the path via JVM properties. The property you need to
# specify is defined in Snippr::Path::JVMProperty. This allows system administrators to change the
# path without having to touch your application.
#
# == Instantiation
#
# Instantiating a new snippr is done by passing in the path to the snippr file as a String
# (including path separators):
#
#   Snippr.load "tariff/einheit"
#
# or by using multiple Strings or Symbols:
#
#   Snippr.load :tariff, :einheit
#
# === Dynamic values
#
# A snippr file may contain placeholders to be replaced with dynamic values. Placeholders are
# wrapped in curly braces.
#
#   <p>You're topup of {topup_amount} at {date_today} was successful.</p>
#
# To replace both {topup_amount} and {date_today} with a dynamic value, you just pass in a Hash of
# placeholders and dynamic values when loading a snippr file.
#
#   Snippr.load :topup, :success, :topup_amount => number_to_currency(15), :date_today => Date.today
#
# The result will obviously be something like:
#
#   <p>You're topup of 15,00 &euro; at 2010-04-03 was successful.</p>
#
# == Rails Helper
#
# When using the Snippr module with Rails, it automatically adds the +Snippr::Helper+ module to
# your views. You can then use the +snippr+ helper method to load snippr files.
#
#   %h1 Topup successful
#   .topup.info
#     = snippr :topup, :success
module Snippr
  extend Snippr::Path
  extend Snippr::I18n

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
      SnipprComments % [@name, content, @name]
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
      content
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
