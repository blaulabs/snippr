module Snippr

  module Normalizer

    class Camelizer

      def normalize(path_element)
        path_element.to_s.camelize(:lower)
      end

    end

  end

end
