# -*- encoding : utf-8 -*-
module Snippr
  module SegmentFilter
    class ValidFrom < Base
      def active?
        DateTime.now.to_s >= DateTime.strptime(@filter_value, "%Y-%m-%d %H:%M").to_s
      rescue ArgumentError
        false
      end
    end
  end
end
