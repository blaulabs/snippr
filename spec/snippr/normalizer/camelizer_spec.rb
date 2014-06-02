require "spec_helper"

describe Snippr::Normalizer::Camelizer do

  it "should leave a string as is" do
    expect(subject.normalize("blaHui_ja")).to eq("blaHui_ja")
  end

  it "should lower camelize a symbol" do
    expect(subject.normalize(:symbol_with_separators)).to eq("symbolWithSeparators")
  end

end
