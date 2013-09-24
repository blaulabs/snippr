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
    Snippr::SegmentFilter::OnRailsEnv.new("test").should be_active
  end

  it "is not active in other environments" do
    Snippr::SegmentFilter::OnRailsEnv.new("non-existing-env").should_not be_active
  end

  it "allows multiple environments to be given" do
    Snippr::SegmentFilter::OnRailsEnv.new("a_env, test, development,     foobar").should be_active
  end
end
