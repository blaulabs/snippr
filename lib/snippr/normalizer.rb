# = Snippr::Normalizer
#
# Provides methods to normalize snippr path elements.
module Snippr
  module Normalizer

    # Returns a (modifiable) list of normalizers that'll be used to normalize a path element.
    def self.normalizers
      @normalizers ||= []
    end

    # Sends the given path element to all the configured normalizers and returns the result.
    def self.normalize(path_element)
      @normalizers.inject(path_element) {|e, normalizer| normalizer.normalize e}
    end

  end
end
