require "logger"

# = Snippr
# ==== File based content management
#
# A snippr file is a piece of HTML or raw text to be included in a website. They are plain text
# files stored on the file system. Snippr files end with ".snip" and are read from the Snippr path.
module Snippr
  extend self

  # Returns the path to the snippr files (from JVM properties if available).
  def path
    Path.path
  end

  # Sets the path to the snippr files.
  def path=(path)
    Path.path = path
  end

  # Returns whether to use I18n snippr files.
  def i18n?
    I18n.enabled?
  end

  # Sets whether to use I18n snippr files.
  def i18n=(enabled)
    I18n.enabled = enabled
  end

  # Returns the regular expressions used to determine which urls to exclude from adjustment.
  def adjust_urls_except
    Links.adjust_urls_except
  end

  # Sets the regular expressions used to determine which urls to exclude from adjustment.
  def adjust_urls_except=(adjust_urls_except)
    Links.adjust_urls_except = adjust_urls_except
  end

  # Sets the logger to use.
  attr_writer :logger

  # Returns the logger. Uses the Rails logger when available or falls back to a custom logger.
  def logger
    @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
  end

  # Expects the name of a snippr file. Also accepts a Hash of placeholders
  # to be replaced with dynamic values.
  def load(*args)
    Snip.new(*args)
  end

  # Lists all snips inside a snippr directory specified by path parts.
  def list(*args)
    Path.list *args
  end

end
