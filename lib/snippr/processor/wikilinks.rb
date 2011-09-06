# = Snippr::Processor::Wikilinks
#
# Replaces links in [url|title] syntax with real links.
module Snippr

  module Processor

    class Wikilinks

      def process(content, opts = {})
        content.gsub /\[\[([^|]+)\|([^\]]+)\]\]/ do |match|
          Snippr::Links.adjust_link "<a href=\"#{$1}\">#{$2}</a>"
        end
      end

    end

  end

end
