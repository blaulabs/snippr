# = Snippr::Normalizer::Camelizer
#
# When given a symbol, normalizes it to a lower camelized string, otherwise just returns the given string.
module Snippr

  module Normalizer

    class Camelizer

      def normalize(path_element)
        path_element.kind_of?(Symbol) ? path_element.to_s.camelize(:lower) : path_element
      end

    end

  end

end
