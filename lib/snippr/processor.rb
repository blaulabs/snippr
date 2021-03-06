# -*- encoding : utf-8 -*-
# = Snippr::Processor
#
# Provides methods to process snippr content.
module Snippr
  module Processor

    # Returns a (modifiable) list of processors that'll be used to process the content.
    def self.processors
      @processors ||= []
    end

    # Sends the given content and opts to all the configured processors and returns the result.
    def self.process(content, opts, including_snippet)
      opts[:_parent] = including_snippet
      @processors.inject(content) {|c, processor| processor.process c, opts}
    end

  end
end
