require "spec_helper"

# HACK for testing of rails specific stuff
module ActionController; class Base; end; end

describe Snippr do

  it "should delegate path= to Snippr::Path.path=" do
    Snippr::Path.should respond_to(:path=)
    Snippr::Path.expects(:path=).with('path')
    Snippr.path = 'path'
  end

  it "should delegate path to Snippr::Path.path" do
    Snippr::Path.should respond_to(:path)
    Snippr::Path.expects(:path).returns('path')
    Snippr.path.should == 'path'
  end

  it "should delegate i18n= to Snippr::I18n.enabled=" do
    Snippr::I18n.should respond_to(:enabled=)
    Snippr::I18n.expects(:enabled=).with(true)
    Snippr.i18n = true
  end

  it "should delegate i18n? to Snippr::I18n.enabled?" do
    Snippr::I18n.should respond_to(:enabled?)
    Snippr::I18n.expects(:enabled?).returns(true)
    Snippr.i18n?.should == true
  end

  it "should delegate load to Snippr::Snip.new" do
    Snippr::Snip.expects(:new).with(:a, :b).returns('snip')
    Snippr.load(:a, :b).should == 'snip'
  end

  it "should delegate list to Snippr::Path.list" do
    Snippr::Path.expects(:list).with(:c, :d).returns([:snip])
    Snippr.list(:c, :d).should == [:snip]
  end

end
