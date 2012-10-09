module Snippr

  module Normalizer

    class Camelizer

      def normalize(path_element)
        path_element.kind_of?(Symbol) ? path_element.to_s.camelize(:lower) : path_element
      end

    end

  end

end
