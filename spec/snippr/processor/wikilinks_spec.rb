require "spec_helper"

describe Snippr::Processor::Wikilinks do

  before do
    @processor = Snippr::Processor::Wikilinks.new
  end

  it "should convert http wiki links to an anchor with the link" do
    @processor.process('click [[http://www.blaulabs.de|here with blanks]]').should == 'click <a href="http://www.blaulabs.de">here with blanks</a>'
  end

  it "should convert https wiki links to an anchor with the link" do
    @processor.process('click [[https://www.blaulabs.de|here with blanks]]').should == 'click <a href="https://www.blaulabs.de">here with blanks</a>'
  end

  it "should convert mailto wiki links to an anchor with the link" do
    @processor.process('click [[mailto:info@example.com|here with blanks]]').should == 'click <a href="mailto:info@example.com">here with blanks</a>'
  end

  it "should convert relative wiki links to an anchor with the absolute link" do
    @processor.process('click [[relative.html|here with blanks]]').should == 'click <a href="/relative.html">here with blanks</a>'
  end

  it "should convert server absolute wiki links to an anchor with the absolute link" do
    @processor.process('click [[/absolute.html|here with blanks]]').should == 'click <a href="/absolute.html">here with blanks</a>'
  end

end
