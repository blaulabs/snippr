module Snippr
  module SegmentFilter
    class Base

      def initialize(filter_value)
        @filter_value = filter_value
      end

      def self.filters
        @available_filters
      end

      def self.inherited(subclass)
        @available_filters ||= []
        @available_filters << subclass
      end

      def active?
        raise RuntimeException("Subclasses need to implement #active?")
      end
    end
  end
end
