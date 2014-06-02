# -*- encoding : utf-8 -*-
require "spec_helper"
require "snippr/segment_filter/on_rails_env"

describe "Snippr::SegmentFilter::OnRailsEnv" do
  before do
    Rails = Class.new { def self.env; "test"; end}
  end

  after do
    Object.send(:remove_const, :Rails)
  end

  it "is active in the defined environment" do
    expect(Rails).to receive(:env).and_return("test")
    expect(Snippr::SegmentFilter::OnRailsEnv.new("test")).to be_active
  end

  it "is not active in other environments" do
    expect(Snippr::SegmentFilter::OnRailsEnv.new("non-existing-env")).not_to be_active
  end

  it "allows multiple environments to be given" do
    expect(Snippr::SegmentFilter::OnRailsEnv.new("a_env, test, development,     foobar")).to be_active
  end
end
