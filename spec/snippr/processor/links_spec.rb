require "spec_helper"

describe Snippr::Processor::Links do

  it "should call Snippr::Links.adjust_link with the links found and return the results" do
    processor = Snippr::Processor::Links.new
    seq = sequence 'links'
    Snippr::Links.expects(:adjust_link).with('<a href="http://www.blaulabs.de" onclick="return true;">here</a>').in_sequence(seq).returns('--here--')
    Snippr::Links.expects(:adjust_link).with('<A class=\'link\' href="internal.html">or here</A>').in_sequence(seq).returns('--or here--')
    processor.process('click <a href="http://www.blaulabs.de" onclick="return true;">here</a> <A class=\'link\' href="internal.html">or here</A>').should == 'click --here-- --or here--'
  end

end
