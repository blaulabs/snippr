# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::Clock" do

  before do
    Snippr::Clock.reset
  end

  describe ".now" do
    # use TimeCop here
    it "returns a time object" do
      expect(Snippr::Clock.now).to be_a(Time)
    end

    it "returns the current time if no interval is given" do
      expect(Snippr::Clock.now.to_i).to eq(Time.now.to_i)
    end

    it "returns the modified time if an interval is set" do
      Snippr::Clock.interval="+1d"
      expect(Snippr::Clock.now.to_i).to eq((Time.now + 86400).to_i)
    end

  end

  describe ".reset" do
    it "resets the time" do
      Snippr::Clock.interval="+1d"
      Snippr::Clock.reset
      expect(Snippr::Clock.now.to_i).to eq(Time.now.to_i)
    end
  end

  describe ".interval=" do
    it "sets the time forward" do
      Snippr::Clock.interval="+1m"
      expect(Snippr::Clock.interval).to eq +60
    end

    it "sets the time backward" do
      Snippr::Clock.interval="-1m"
      expect(Snippr::Clock.interval).to eq(-60)
    end

    it "accepts seconds as scale" do
      Snippr::Clock.interval="+1s"
      expect(Snippr::Clock.interval).to eq +1
    end

    it "accepts minutes as scale" do
      Snippr::Clock.interval="+1m"
      expect(Snippr::Clock.interval).to eq +60
    end

    it "accepts hours as scale" do
      Snippr::Clock.interval="+1h"
      expect(Snippr::Clock.interval).to eq +3600
    end

    it "accepts days as scale" do
      Snippr::Clock.interval="+1d"
      expect(Snippr::Clock.interval).to eq +86400
    end

    it "doesn't set the time if the interval is invalid" do
      Snippr::Clock.interval="blubb"
      expect(Snippr::Clock.interval).to eq(1)
    end
  end

  describe "interval" do
    it "returns the interval in seconds" do
      expect(Snippr::Clock.interval).to eq(0)
    end
  end
end
