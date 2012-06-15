# # -*- encoding : utf-8 -*-
# = Snippr::Normalizer
#
# Provides methods to normalize snippr path elements.
module Snippr
  module Normalizer

    # Returns a (modifiable) list of normalizers that'll be used to normalize a path element.
    def self.normalizers
      @normalizers ||= []
    end

    def self.add(normalizer_or_normalizers)
      @normalizers = Array(@normalizers) + Array(normalizer_or_normalizers)
    end

    # Sends the given path element to all the configured normalizers and returns the result.
    def self.normalize(path_element)
      @normalizers.inject(path_element) {|e, normalizer| normalizer.normalize e}
    end

  end
end
