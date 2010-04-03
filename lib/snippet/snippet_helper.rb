# = SnippetHelper
#
# This module is automatically included into +ActionView::Base+ when using the Snippet
# component with Rails. It provides a +snippet+ helper method for loading snippets.
#
#   %h1 Topup successful
#   .topup.info
#     = snippet :topup, :success
module SnippetHelper

  # Returns a snippet specified via +args+.
  def snippet(*args)
    Snippet.new(*args).to_s
  end

end