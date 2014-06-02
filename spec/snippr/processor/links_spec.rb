# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Processor::Links do

  it "should call Snippr::Links.adjust_link with the links found and return the results" do
    expect(Snippr::Links).to receive(:adjust_link).with('<a href="http://www.blaulabs.de" onclick="return true;">here</a>').and_return('--here--')
    expect(Snippr::Links).to receive(:adjust_link).with('<A class=\'link\' href="internal.html">or here</A>').and_return('--or here--')
    expect(subject.process('click <a href="http://www.blaulabs.de" onclick="return true;">here</a> <A class=\'link\' href="internal.html">or here</A>')).to eq('click --here-- --or here--')
  end

end
