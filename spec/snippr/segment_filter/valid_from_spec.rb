# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::SegmentFilter::ValidFrom" do
  it "returns true if the filter date is before now" do
    Snippr::SegmentFilter::ValidFrom.new("1976-03-10 09:00:00").should be_active
  end

  it "returns false if the filter date is after now" do
    Snippr::SegmentFilter::ValidFrom.new("9999-03-10 09:00:00").should_not be_active
  end

  it "returns false if the filter date is unparsable" do
    Snippr::SegmentFilter::ValidFrom.new("99990310090000").should_not be_active
  end
end
