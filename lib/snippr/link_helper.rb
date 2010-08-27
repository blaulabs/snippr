# = Snippr::LinkHelper
#
# This module can be included to get functionality to enhance links.
module Snippr
  module LinkHelper

    HREF_REGEX = /(href *= *['"])([^'"]*)(['"])/i

    def enhance_link(link)
      return link if link !~ HREF_REGEX
      url = $2
      if url =~ /popup:\/*(.*)$/i
        url = enhance_url $1
        onclick = "onclick=\"if (typeof popup == 'undefined') { return true; } else { popup('#{url}'); return false; }\""
        # replace an existing onclick (if present)
        link_with_onclick = link.gsub /onclick *= *['"][^'"]*['"]/i, onclick
        # add a new onclick (when there was no existing onclick)
        link_with_onclick = link.gsub(/(^[^>]+)>/, "\\1 #{onclick}>") if link_with_onclick == link
        link = link_with_onclick
      else
        url = enhance_url url
      end
      link.gsub HREF_REGEX, "\\1#{url}\\3"
    end

    def enhance_url(url)
      url =~ /^[a-z]+:/i ? url : url.gsub(/^\/?/, relative_url_root)
    end

    def relative_url_root
      if defined? ActionController::Base
        root = ActionController::Base.config.relative_url_root || '/'
        root = "/#{root}" unless root.start_with?('/')
        root << '/' unless root.end_with?('/')
        root
      else
        '/'
      end
    end

  end
end
