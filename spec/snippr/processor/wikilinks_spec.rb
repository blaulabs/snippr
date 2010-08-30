require "spec_helper"

describe Snippr::Processor::Wikilinks do

  it "should call Snippr::Links.adjust_link with the links found and return the results" do
    processor = Snippr::Processor::Wikilinks.new
    seq = sequence 'wikilinks'
    Snippr::Links.expects(:adjust_link).with('<a href="http://www.blaulabs.de">here</a>').in_sequence(seq).returns('--here--')
    Snippr::Links.expects(:adjust_link).with('<a href="internal.html">or here</a>').in_sequence(seq).returns('--or here--')
    processor.process('click [[http://www.blaulabs.de|here]] [[internal.html|or here]]').should == 'click --here-- --or here--'
  end

end
