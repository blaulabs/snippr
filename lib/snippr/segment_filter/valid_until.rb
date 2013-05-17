# -*- encoding : utf-8 -*-
module Snippr
  module SegmentFilter
    class ValidUntil < Base
      def active?
        DateTime.now <= DateTime.strptime(@filter_value, "%Y-%m-%d %H:%M:%S")
      rescue ArgumentError
        false
      end
    end
  end
end
