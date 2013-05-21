# -*- encoding : utf-8 -*-
require "spec_helper"

describe "SegmentParser" do

  it "allows scissor symbols to be the delimiter. yay!" do
    actual = Snippr::SegmentParser.new("a\n=✄== valid_from: 3099-05-01 09:00:00 ====\nb").content.should == "a"
  end

  it "chooses the correct segment if no condition is given" do
    actual = Snippr::SegmentParser.new("a\nb").content.should == "a\nb"
  end

  it "chooses the correct segment if no valid condition is given" do
    actual = Snippr::SegmentParser.new("a\n==== valid_from: 3099-05-01 09:00:00 ====\nb").content.should == "a"
  end

  it "chooses the correct segment if a valid condition is given" do
    actual = Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====\nb").content.should == "b"
  end

end
