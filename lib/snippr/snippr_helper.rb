# = SnipprHelper
#
# This module is automatically included into +ActionView::Base+ when using the Snippr
# component with Rails. It provides a +snippr+ helper method for loading snipprs.
#
#   %h1 Topup successful
#   .topup.info
#     = snippr :topup, :success
module SnipprHelper

  # Returns a snippr specified via +args+.
  def snippr(*args)
    Snippr.new(*args).to_s
  end

end

if defined? ActionView::Base
  ActionView::Base.send :include, SnipprHelper
end