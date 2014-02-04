# -*- encoding : utf-8 -*-
module Snippr
  module SegmentFilter
    class ValidBetween < Base
      def active?
        Snippr::Clock.now.to_s >= valid_from && Snippr::Clock.now.to_s <= valid_until
      rescue ArgumentError
        false
      end

      private

      def valid_from
        @valid_from ||= DateTime.strptime(@filter_value, "%Y-%m-%d %H:%M").to_s
      end

      def valid_until
        @valid_until ||= begin
          date_until = @filter_value.match(/([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}(?::[0-9]{2})?)$/)
          raise ArgumentError.new("valid_until date not parsable. Full filter value was: '#{@filter_value}'") if date_until.nil?
          DateTime.strptime(date_until[1], "%Y-%m-%d %H:%M").to_s
        end
      end

    end
  end
end
