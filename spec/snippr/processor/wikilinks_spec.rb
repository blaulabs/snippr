require "spec_helper"

describe Snippr::Processor::Wikilinks do

  it "should include Snippr::LinkHelper" do
    Snippr::Processor::Wikilinks.included_modules.should include(Snippr::LinkHelper)
  end

  it "should call enhance_link with the links found and return the results" do
    processor = Snippr::Processor::Wikilinks.new
    seq = sequence 'wikilinks'
    processor.expects(:enhance_link).with('<a href="http://www.blaulabs.de">here</a>').in_sequence(seq).returns('--here--')
    processor.expects(:enhance_link).with('<a href="internal.html">or here</a>').in_sequence(seq).returns('--or here--')
    processor.process('click [[http://www.blaulabs.de|here]] [[internal.html|or here]]').should == 'click --here-- --or here--'
  end

end
