# -*- encoding : utf-8 -*-
module Snippr
  class Clock
    def self.now
      @interval_sec ||= 0
      Time.now + @interval_sec
    end

    def self.interval=(interval="0s")
      reset
      @interval_sec = parse(interval)
    end

    def self.interval
      @interval_sec
    end

    def self.reset
      @interval_sec = 0
      now
    end

    private

    def self.parse(interval)
      return 1 unless interval =~ /[+-][0-9]+[smhd]/

      multiplicator = case interval[-1]
                      when "m" then
                        60
                      when "h" then
                        3600
                      when "d" then
                        86400
                      else
                        1
                      end
      @interval_sec = interval[0...-1].to_i*multiplicator
    end
  end
end
