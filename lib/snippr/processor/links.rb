module Snippr

  module Processor

    class Links

      include LinkHelper

      def process(content, opts = {})
        content.gsub /<a [^>]+>[^<]*<\/a>/i do |match|
          enhance_link match
        end
      end

    end

  end

end
