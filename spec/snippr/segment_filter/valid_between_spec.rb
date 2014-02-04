# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::SegmentFilter::ValidBetween" do
  it "returns true if 'now' is between the filter dates" do
    Snippr::SegmentFilter::ValidBetween.new("1976-03-10 09:00:00 - 9999-09-01 23:59:59").should be_active
  end

  it "returns false if 'now' is outside the filter dates" do
    Snippr::SegmentFilter::ValidBetween.new("1976-03-10 09:00:00 - 1977-09-01 23:59:59").should_not be_active
  end

  it "returns false if the from date is not parsable" do
    Snippr::SegmentFilter::ValidBetween.new("xxxx-03-10 09:00:00 - 1977-09-01 23:59:59").should_not be_active
  end

  it "returns false if the until date is not parsable" do
    Snippr::SegmentFilter::ValidBetween.new("1976-03-10 09:00:00 - xxxx-09-01 23:59:59").should_not be_active
  end
end
