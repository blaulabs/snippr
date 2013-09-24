# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr do

  it "delegates path to Snippr::Path.path" do
    Snippr::Path.should respond_to(:path)
    Snippr::Path.should_receive(:path).and_return('path')
    subject.path.should == 'path'
  end

  it "delegates path= to Snippr::Path.path=" do
    Snippr::Path.should respond_to(:path=)
    Snippr::Path.should_receive(:path=).with('path')
    subject.path = 'path'
  end

  it "delegates tardis= to Snippr::Tardis.enabled=" do
    Snippr::Tardis.should_receive(:enabled=).with(true)
    subject.tardis_enabled = true
  end

  it "delegates tardis to Snippr::Tardis.enabled" do
    Snippr::Tardis.should respond_to(:enabled)
    Snippr::Tardis.should_receive(:enabled)
    subject.tardis_enabled
  end

  it "delegates i18n? to Snippr::I18n.enabled?" do
    Snippr::I18n.should respond_to(:enabled?)
    Snippr::I18n.should_receive(:enabled?).and_return(true)
    subject.i18n?.should == true
  end

  it "delegates i18n= to Snippr::I18n.enabled=" do
    Snippr::I18n.should respond_to(:enabled=)
    Snippr::I18n.should_receive(:enabled=).with(true)
    subject.i18n = true
  end

  it "delegates adjust_urls_except? to Snippr::Links.adjust_urls_except" do
    Snippr::Links.should respond_to(:adjust_urls_except)
    Snippr::Links.should_receive(:adjust_urls_except).and_return([1])
    subject.adjust_urls_except.should == [1]
  end

  it "delegates adjust_urls_except= to Snippr::Links.adjust_urls_except=" do
    Snippr::Links.should respond_to(:adjust_urls_except=)
    Snippr::Links.should_receive(:adjust_urls_except=).with([2])
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

  it "delegates load to Snippr::Snip.new" do
    Snippr::Snip.should_receive(:new).with(:a, :b).and_return('snip')
    subject.load(:a, :b).should == 'snip'
  end

  it "delegates list to Snippr::Path.list" do
    Snippr::Path.should_receive(:list).with(:c, :d).and_return([:snip])
    subject.list(:c, :d).should == [:snip]
  end

end
