# -*- encoding : utf-8 -*-
module Snippr

  module Processor

    class Block

      def process(content, opts = {})
        opts.inject(content) do |c, pv|
          placeholder, value = pv
          c.gsub(/\{(.*)\((.*)\)\}(.*)\{\/\1\}/m) do |match|
            # match[0] = {a.b("1","2")} INNEN {/a.b}
            # match[1] = a.b
            # match[2] = "1","2"
            # match[3] =  INNEN
            message = $1
            signature = $2
            block_quoted = $3.gsub("\"","\"").strip
            new_signature = []
            new_signature << signature unless signature.empty?
            new_signature << block_quoted unless block_quoted.empty?
            "{#{message}(#{new_signature.map { |e| "\"#{e}\""}.join(',')})}"
          end
        end
      end

    end

  end

end
