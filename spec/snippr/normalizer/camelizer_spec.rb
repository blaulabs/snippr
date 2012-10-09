require "spec_helper"

describe Snippr::Normalizer::Camelizer do

  it "should leave a string as is" do
    subject.normalize("blaHui_ja").should == "blaHui_ja"
  end

  it "should lower camelize a symbol" do
    subject.normalize(:symbol_with_separators).should == "symbolWithSeparators"
  end

end
