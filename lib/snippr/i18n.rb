require "i18n"

# = Snippr::I18n
#
# Extends the Snippr module adding support for I18n snippr files.
module Snippr
  module I18n

    # Sets whether to use I18n snippr files.
    def i18n=(enabled)
      @enabled = enabled
    end

    # Returns whether to use I18n snippr files.
    def i18n?
      !!@enabled
    end

    # Returns the current locale prefixed with a "_" from I18n if I18n is enabled.
    # Otherwise defaults to an empty String.
    def locale
      return "" unless i18n?
      ["_", ::I18n.locale].join
    end

  end
end
