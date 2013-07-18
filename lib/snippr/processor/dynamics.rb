# -*- encoding : utf-8 -*-
# = Snippr::Processor::Dynamics
#
# Replaces {placeholder} placeholders in the content with values taken from the given opts.
module Snippr

  module Processor

    class Dynamics

      def process(content, opts = {})
        opts.inject(content) do |c, pv|
          placeholder, value = pv
          c.gsub(/\{(!?)#{placeholder}(?:\.(.*?)\(["]?(.*?)["]?\))?\}/m) do |match|
            if $2 && (value.respond_to?($2) || $1 == "!")
              method = $2
              params = ($3 || "").gsub(/[\t\r\n]/,"").split("\",\"")
              value.send(method, *params).to_s
            elsif $2
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
