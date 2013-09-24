# -*- encoding : utf-8 -*-
require "spec_helper"

describe "Snippr::SegmentFilter::OnHoAst" do
  before do
    allow(Socket).to receive(:gethostname).and_return("thishost")
  end

  it "is active on the given host" do
    Snippr::SegmentFilter::OnHost.new("thishost").should be_active
  end

  it "inactive on other than the given host" do
    Snippr::SegmentFilter::OnHost.new("thathost").should_not be_active
  end

  it "allows multiple hostnames to be given" do
    Snippr::SegmentFilter::OnHost.new("ahost, , thishost,     foobarhost").should be_active
  end
end
