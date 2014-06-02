# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::SegmentFilter::ValidUntil" do
  it "returns false if the filter date is before now" do
    expect(Snippr::SegmentFilter::ValidUntil.new("1976-03-10 09:00:00")).not_to be_active
  end

  it "returns true if the filter date is after now" do
    expect(Snippr::SegmentFilter::ValidUntil.new("9999-03-10 09:00:00")).to be_active
  end

  it "returns false if the filter date is unparsable" do
    expect(Snippr::SegmentFilter::ValidUntil.new("99990310090000")).not_to be_active
  end
end
