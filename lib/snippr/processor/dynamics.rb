module Snippr

  module Processor

    class Dynamics

      def process(content, opts = {})
        opts.inject(content) do |c, pv|
          placeholder, value = pv
          c.gsub "{#{placeholder}}", value.to_s
        end
      end

    end

  end

end
