# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Processor::Wikilinks do

  it "should call Snippr::Links.adjust_link with the links found and return the results" do
    expect(Snippr::Links).to receive(:adjust_link).with('<a href="http://www.blaulabs.de">here</a>').and_return('--here--')
    expect(Snippr::Links).to receive(:adjust_link).with('<a href="internal.html">or here</a>').and_return('--or here--')
    subject.process('click [[http://www.blaulabs.de|here]] [[internal.html|or here]]').should == 'click --here-- --or here--'
  end

end
