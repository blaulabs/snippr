# -*- encoding : utf-8 -*-
require "spec_helper"

describe "SegmentParser" do

  it "allows scissor symbols to be the delimiter. yay!" do
    Snippr::SegmentParser.new("a\n=✄== valid_from: 3099-05-01 09:00:00 ====\nb").content.should == "a"
  end

  it "chooses the correct segment if no condition is given" do
    Snippr::SegmentParser.new("a\nb").content.should == "a\nb"
  end

  it "chooses the correct segment if no valid condition is given" do
    Snippr::SegmentParser.new("a\n==== valid_from: 3099-05-01 09:00:00 ====\nb").content.should == "a"
  end

  it "chooses the correct segment if a valid condition is given" do
    Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====\nb").content.should == "b"
  end

  it "returns the first matching segment if multiple segments are given" do
    Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====\nb\n==== valid_from: 1100-05-01 09:00:00 ====\nc").content.should == "b"
  end

  it "can handle more than two segments" do
    Snippr::SegmentParser.new("a\n==== valid_from: 6099-05-01 09:00:00 ====\nb\n==== valid_from: 1100-05-01 09:00:00 ====\nc").content.should == "c"
  end

  it "doesn't need a newline after the last segment" do
    Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====").content.should be_empty
  end
end
