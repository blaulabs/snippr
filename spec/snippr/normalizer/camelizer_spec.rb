require "spec_helper"

describe Snippr::Normalizer::Camelizer do

  it "should lower camelize a symbol" do
    subject.normalize(:symbol_with_separators).should == "symbolWithSeparators"
  end

  it "should lower camelize a string" do
    subject.normalize("string_with_separators").should == "stringWithSeparators"
    subject.normalize("blaHui_ja").should == "blaHuiJa"
  end

end
