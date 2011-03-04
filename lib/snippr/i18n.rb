require "i18n"

# = Snippr::I18n
#
# Provides support for I18n snippr files.
module Snippr
  module I18n

    # Returns whether to use I18n snippr files.
    def self.enabled?
      !!@@enabled
    end

    # Sets whether to use I18n snippr files.
    def self.enabled=(enabled)
      @@enabled = enabled
    end

    # Returns the current locale prefixed with a "_" from I18n if I18n is enabled.
    # Otherwise defaults to an empty String.
    def self.locale(enabled=nil)
      (enabled.nil? ? enabled? : enabled) ? "_#{::I18n.locale}" : ''
    end

  end
end
