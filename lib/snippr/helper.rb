# = Snippr::Helper
#
# This module is automatically included into +ActionView::Base+ when using the Snippr
# component with Rails. It provides a +snippr+ helper method for loading snippr files.
#
#   %h1 Topup successful
#   .topup.info
#     = snippr :topup, :success
module Snippr
  module Helper

    # Returns a snippr specified via +args+.
    def snippr(*args)
      Snippr.load *args
    end

  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, Snippr::Helper
end
