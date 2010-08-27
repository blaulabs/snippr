module Snippr

  module Processor

    class Wikilinks

      include LinkHelper

      def process(content, opts = {})
        content.gsub /\[\[([^|]+)\|([^\]]+)\]\]/ do |match|
          enhance_link "<a href=\"#{$1}\">#{$2}</a>"
        end
      end

    end

  end

end