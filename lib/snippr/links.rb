# = Snippr::LinkHelper
#
# This module can be included to get functionality to adjust links.
module Snippr
  module Links

    HREF_REGEX = /(href *= *['"])([^'"]*)(['"])/i

    # Returns the regular expressions used to determine which urls to exclude from adjustment.
    def self.adjust_urls_except
      @@adjust_urls_except ||= [/^#/, /^[a-z]+:/i]
    end

    # Sets the regular expressions used to determine which urls to exclude from adjustment.
    def self.adjust_urls_except=(adjust_urls_except)
      @@adjust_urls_except = adjust_urls_except
    end

    # Adjusts a complete anchor tag, allowing the custom protocol popup: which will be converted to a javascript call to popup(this).
    def self.adjust_link(link)
      return link if link !~ HREF_REGEX
      url = $2
      if url =~ /popup:\/*(.*)$/i
        url = adjust_url $1
        onclick = "onclick=\"if (typeof popup == 'undefined') { return true; } else { popup(this); return false; }\""
        # replace an existing onclick (if present)
        link_with_onclick = link.gsub /onclick *= *['"][^'"]*['"]/i, onclick
        # add a new onclick (when there was no existing onclick)
        link_with_onclick = link.gsub /(^[^>]+)>/, "\\1 #{onclick}>" if link_with_onclick == link
        link = link_with_onclick
      else
        url = adjust_url url
      end
      link.gsub HREF_REGEX, "\\1#{url}\\3"
    end

    # Adjusts an url, prepending / and relative url root (context path) as needed.
    def self.adjust_url(url)
      adjust_urls_except.each do |regex|
        return url if url =~ regex
      end
      root = relative_url_root
      url.gsub(/^(#{root}|\/)?/, root)
    end

    # Returns the relative url root (context path) the application is deployed to.
    def self.relative_url_root
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
