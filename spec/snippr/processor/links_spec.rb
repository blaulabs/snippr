require "spec_helper"

describe Snippr::Processor::Links do

  it "should include Snippr::LinkHelper" do
    Snippr::Processor::Links.included_modules.should include(Snippr::LinkHelper)
  end

  it "should call enhance_link with the links found and return the results" do
    processor = Snippr::Processor::Links.new
    seq = sequence 'links'
    processor.expects(:enhance_link).with('<a href="http://www.blaulabs.de" onclick="return true;">here</a>').in_sequence(seq).returns('--here--')
    processor.expects(:enhance_link).with('<A class=\'link\' href="internal.html">or here</A>').in_sequence(seq).returns('--or here--')
    processor.process('click <a href="http://www.blaulabs.de" onclick="return true;">here</a> <A class=\'link\' href="internal.html">or here</A>').should == 'click --here-- --or here--'
  end

end
