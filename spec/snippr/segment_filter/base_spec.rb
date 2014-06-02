# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::SegmentFilter::Base" do
  it "remembers its subclasses" do
    expect(Snippr::SegmentFilter::Base.filters.size).to eq(5)
  end
end
