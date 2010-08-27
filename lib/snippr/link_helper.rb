# = Snippr::LinkHelper
#
# This module can be included to get functionality to enhance links.
module Snippr
  module LinkHelper

    def enhance_link(link)
      link =~ /^[a-z]+:/ ? link : link.gsub(/^\/?/, '/')
    end

  end
end
