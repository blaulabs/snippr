module Snippr

  module Processor

    class Wikilinks

      def process(content, opts = {})
        content.gsub /\[\[([^|]+)\|([^\]]+)\]\]/ do |match|
          link, text = $1, $2
          link = link.gsub(/^\/?/, '/') unless link =~ /^[a-z]+:/
          "<a href=\"#{link}\">#{text}</a>"
        end
      end

    end

  end

end
