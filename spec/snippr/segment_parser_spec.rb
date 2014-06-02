# -*- encoding : utf-8 -*-
require "spec_helper"

describe "SegmentParser" do

  it "allows scissor symbols to be the delimiter. yay!" do
    expect(Snippr::SegmentParser.new("a\n=✄== valid_from: 3099-05-01 09:00:00 ====\nb").content).to eq("a")
  end

  it "chooses the correct segment if no condition is given" do
    expect(Snippr::SegmentParser.new("a\nb").content).to eq("a\nb")
  end

  it "chooses the correct segment if no valid condition is given" do
    expect(Snippr::SegmentParser.new("a\n==== valid_from: 3099-05-01 09:00:00 ====\nb").content).to eq("a")
  end

  it "chooses the correct segment if a valid condition is given" do
    expect(Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====\nb").content).to eq("b")
  end

  it "returns the first matching segment if multiple segments are given" do
    expect(Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====\nb\n==== valid_from: 1100-05-01 09:00:00 ====\nc").content).to eq("b")
  end

  it "can handle more than two segments" do
    expect(Snippr::SegmentParser.new("a\n==== valid_from: 6099-05-01 09:00:00 ====\nb\n==== valid_from: 1100-05-01 09:00:00 ====\nc").content).to eq("c")
  end

  it "doesn't need a newline after the last segment" do
    expect(Snippr::SegmentParser.new("a\n==== valid_from: 1099-05-01 09:00:00 ====").content).to be_empty
  end

  it "chooses the correct segment even with \r\n" do
    expect(Snippr::SegmentParser.new("alt\r\n==== valid_from: 1099-05-01 09:00:00 ====\r\nneu\r\n").content).to eq("neu")
  end

  it 'works with yml block in old block' do
    expect(Snippr::SegmentParser.new("---\nyml_key: yml_value\nalt\n==== valid_from: 1099-05-01 09:00:00 ====\nneu\n").content).to eq("neu")
  end

  it 'works with yml block in new block' do
    expect(Snippr::SegmentParser.new("---\nyml_key: yml_value\n---\nalt\n==== valid_from: 1099-05-01 09:00:00 ====\n---\nyml_key: yml_value\n---\nneu\n").content).to eq("---\nyml_key: yml_value\n---\nneu")
  end
end
