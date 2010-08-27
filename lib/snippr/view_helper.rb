# = Snippr::ViewHelper
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
  module ViewHelper

    # Returns a snippr specified via +args+.
    def snippr(*args)
      snip = Snip.new *args
      content = snip.content.html_safe
      if block_given?
        if snip.missing? || snip.blank?
          concat content
        elsif !content.strip.blank?
          yield content
        end
        0
      else
        content
      end
    end

  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, Snippr::ViewHelper
end
