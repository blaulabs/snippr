require "spec_helper"

describe Snippr do

  it "should delegate path to Snippr::Path.path" do
    Snippr::Path.should respond_to(:path)
    Snippr::Path.expects(:path).returns('path')
    subject.path.should == 'path'
  end

  it "should delegate path= to Snippr::Path.path=" do
    Snippr::Path.should respond_to(:path=)
    Snippr::Path.expects(:path=).with('path')
    subject.path = 'path'
  end

  it "should delegate i18n? to Snippr::I18n.enabled?" do
    Snippr::I18n.should respond_to(:enabled?)
    Snippr::I18n.expects(:enabled?).returns(true)
    subject.i18n?.should == true
  end

  it "should delegate i18n= to Snippr::I18n.enabled=" do
    Snippr::I18n.should respond_to(:enabled=)
    Snippr::I18n.expects(:enabled=).with(true)
    subject.i18n = true
  end

  it "should delegate adjust_urls_except? to Snippr::Links.adjust_urls_except" do
    Snippr::Links.should respond_to(:adjust_urls_except)
    Snippr::Links.expects(:adjust_urls_except).returns([1])
    subject.adjust_urls_except.should == [1]
  end

  it "should delegate adjust_urls_except= to Snippr::Links.adjust_urls_except=" do
    Snippr::Links.should respond_to(:adjust_urls_except=)
    Snippr::Links.expects(:adjust_urls_except=).with([2])
    subject.adjust_urls_except = [2]
  end

  context "the logger" do

    after do
      Snippr.logger = nil
    end

    it "can be configured" do
      Snippr.logger = :logger
      Snippr.logger.should == :logger
    end

    it "defaults to a custom logger" do
      Snippr.logger.should be_a(Logger)
    end

    context "in a Rails app" do

      before do
        Rails = Class.new { def self.logger; :rails_logger end }
      end

      after do
        Object.send(:remove_const, :Rails)
      end

      it "uses the Rails logger" do
        Snippr.logger.should == :rails_logger
      end

    end

  end

  it "should delegate load to Snippr::Snip.new" do
    Snippr::Snip.expects(:new).with(:a, :b).returns('snip')
    subject.load(:a, :b).should == 'snip'
  end

  it "should delegate list to Snippr::Path.list" do
    Snippr::Path.expects(:list).with(:c, :d).returns([:snip])
    subject.list(:c, :d).should == [:snip]
  end

end
