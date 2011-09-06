# = Snippr::Processor::Links
#
# Adjusts URLs in links.
module Snippr

  module Processor

    class Links

      def process(content, opts = {})
        content.gsub /<a [^>]+>[^<]*<\/a>/i do |match|
          Snippr::Links.adjust_link match
        end
      end

    end

  end

end
