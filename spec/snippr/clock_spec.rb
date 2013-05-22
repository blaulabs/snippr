# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::Clock" do

  before do
    Snippr::Clock.reset
  end

  describe ".now" do
    # use TimeCop here
    it "returns a time object" do
      Snippr::Clock.now.should be_a(Time)
    end

    it "returns the current time if no interval is given" do
      Snippr::Clock.now.to_i.should == Time.now.to_i
    end

    it "returns the modified time if an interval is set" do
      Snippr::Clock.interval="+1d"
      Snippr::Clock.now.to_i.should == (Time.now + 86400).to_i
    end

  end

  describe ".reset" do
    it "resets the time" do
      Snippr::Clock.interval="+1d"
      Snippr::Clock.reset
      Snippr::Clock.now.to_i.should == Time.now.to_i
    end
  end

  describe ".interval=" do
    it "sets the time forward" do
      Snippr::Clock.interval="+1m"
      Snippr::Clock.interval.should == +60
    end

    it "sets the time backward" do
      Snippr::Clock.interval="-1m"
      Snippr::Clock.interval.should == -60
    end

    it "accepts seconds as scale" do
      Snippr::Clock.interval="+1s"
      Snippr::Clock.interval.should == +1
    end

    it "accepts minutes as scale" do
      Snippr::Clock.interval="+1m"
      Snippr::Clock.interval.should == +60
    end

    it "accepts hours as scale" do
      Snippr::Clock.interval="+1h"
      Snippr::Clock.interval.should == +3600
    end

    it "accepts days as scale" do
      Snippr::Clock.interval="+1d"
      Snippr::Clock.interval.should == +86400
    end

    it "doesn't set the time if the interval is invalid" do
      Snippr::Clock.interval="blubb"
      Snippr::Clock.interval.should == 1
    end
  end

  describe "interval" do
    it "returns the interval in seconds" do
      Snippr::Clock.interval.should == 0
    end
  end
end
