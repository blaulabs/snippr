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
      pass_to_block = block_given? && !snippr.missing_snippr? && !snippr.strip.empty?
      snippr = snippr.html_safe if snippr.respond_to?(:html_safe)
      snippr = yield snippr if pass_to_block
      snippr
    end

  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, Snippr::Helper
end
