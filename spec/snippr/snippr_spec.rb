# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr do

  it "delegates path to Snippr::Path.path" do
    expect(Snippr::Path).to respond_to(:path)
    expect(Snippr::Path).to receive(:path).and_return('path')
    expect(subject.path).to eq('path')
  end

  it "delegates path= to Snippr::Path.path=" do
    expect(Snippr::Path).to respond_to(:path=)
    expect(Snippr::Path).to receive(:path=).with('path')
    subject.path = 'path'
  end

  it "delegates tardis= to Snippr::Tardis.enabled=" do
    expect(Snippr::Tardis).to receive(:enabled=).with(true)
    subject.tardis_enabled = true
  end

  it "delegates tardis to Snippr::Tardis.enabled" do
    expect(Snippr::Tardis).to respond_to(:enabled)
    expect(Snippr::Tardis).to receive(:enabled)
    subject.tardis_enabled
  end

  it "delegates i18n? to Snippr::I18n.enabled?" do
    expect(Snippr::I18n).to respond_to(:enabled?)
    expect(Snippr::I18n).to receive(:enabled?).and_return(true)
    expect(subject.i18n?).to eq(true)
  end

  it "delegates i18n= to Snippr::I18n.enabled=" do
    expect(Snippr::I18n).to respond_to(:enabled=)
    expect(Snippr::I18n).to receive(:enabled=).with(true)
    subject.i18n = true
  end

  it "delegates adjust_urls_except? to Snippr::Links.adjust_urls_except" do
    expect(Snippr::Links).to respond_to(:adjust_urls_except)
    expect(Snippr::Links).to receive(:adjust_urls_except).and_return([1])
    expect(subject.adjust_urls_except).to eq([1])
  end

  it "delegates adjust_urls_except= to Snippr::Links.adjust_urls_except=" do
    expect(Snippr::Links).to respond_to(:adjust_urls_except=)
    expect(Snippr::Links).to receive(:adjust_urls_except=).with([2])
    subject.adjust_urls_except = [2]
  end

  context "the logger" do

    after do
      Snippr.logger = nil
    end

    it "can be configured" do
      Snippr.logger = :logger
      expect(Snippr.logger).to eq(:logger)
    end

    it "defaults to a custom logger" do
      expect(Snippr.logger).to be_a(Logger)
    end

    context "in a Rails app" do

      before do
        Rails = Class.new { def self.logger; :rails_logger end }
      end

      after do
        Object.send(:remove_const, :Rails)
      end

      it "uses the Rails logger" do
        expect(Snippr.logger).to eq(:rails_logger)
      end

    end

  end

  it "delegates load to Snippr::Snip.new" do
    expect(Snippr::Snip).to receive(:new).with(:a, :b).and_return('snip')
    expect(subject.load(:a, :b)).to eq('snip')
  end

  it "delegates list to Snippr::Path.list" do
    expect(Snippr::Path).to receive(:list).with(:c, :d).and_return([:snip])
    expect(subject.list(:c, :d)).to eq([:snip])
  end

end
