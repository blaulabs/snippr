# -*- encoding : utf-8 -*-
require "socket"

module Snippr
  module SegmentFilter
    class OnHost < Base
      def active?
        if in_env?
          true
        else
          false
        end
      end

      private

      def in_env?
        sources.include?(Socket.hostname)
      end

      def sources
        @sources ||= @filter_value.split(",").map(&:strip)
      end
    end
  end
end
