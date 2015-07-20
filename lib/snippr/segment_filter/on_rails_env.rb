# -*- encoding : utf-8 -*-
module Snippr
  module SegmentFilter
    class OnRailsEnv < Base
      def active?
        if defined?(Rails) && in_env?
          true
        else
          false
        end
      end

      private

      def in_env?
        sources.include?(::Rails.env)
      end

      def sources
        @sources ||= @filter_value.split(",").map(&:strip)
      end
    end
  end
end
