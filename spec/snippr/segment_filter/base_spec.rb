# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::SegmentFilter::Base" do
  it "remembers its subclasses" do
    Snippr::SegmentFilter::Base.should have(4).filters
  end
end
