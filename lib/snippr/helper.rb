# = Snippr::Helper
#
# This module is automatically included into +ActionView::Base+ when using the Snippr
# component with Rails. It provides a +snippr+ helper method for loading snippr files.
#
#   %h1 Topup successful
#   .topup.info
#     = snippr :topup, :success
#   %h1 Conditional output
#   - snippr :topup, :conditional_snippr do |snip|
#     #cond= snip
module Snippr
  module Helper

    # Returns a snippr specified via +args+.
    def snippr(*args)
      snippr = Snippr.load *args
      html_safe = snippr.html_safe
      if block_given?
        if snippr.missing_snippr? || snippr.empty_snippr?
          concat html_safe
        elsif !snippr.strip.empty?
          yield html_safe
        end
        0
      else
        html_safe
      end
    end

  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, Snippr::Helper
end
