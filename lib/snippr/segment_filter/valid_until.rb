# -*- encoding : utf-8 -*-
module Snippr
  module SegmentFilter
    class ValidUntil < Base
      def active?
        Snippr::Clock.now.to_s <= DateTime.strptime(@filter_value, "%Y-%m-%d %H:%M").to_s
      rescue ArgumentError
        false
      end
    end
  end
end
