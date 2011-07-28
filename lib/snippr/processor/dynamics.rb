module Snippr

  module Processor

    class Dynamics

      def process(content, opts = {})
        opts.inject(content) do |c, pv|
          placeholder, value = pv
          c.gsub(/\{#{placeholder}(?:\.(.*?)\(["]?(.*?)["]?\))?\}/) do |match|
            if $1 && value.respond_to?($1)
              method = $1
              params = ($2 || "").split("\",\"")
              value.send(method, *params).to_s
            elsif $1
              match
            else
              value.to_s
            end
          end
        end
      end

    end

  end

end
