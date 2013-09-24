# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Path do

  describe "path" do

    before do
      subject.path = nil
    end

    it "stores the path if set as string" do
      subject.path.should == ''
      subject.path = 'path'
      subject.path.should == 'path'
    end

    it "stores and defers the path evaluation if passed a lambda" do
      subject.path = lambda { "WOW LAMBDA ACTION!" }
      subject.path.should == "WOW LAMBDA ACTION!"
    end

  end

  describe ".normalize_name" do

    it "calls Snippr::Normalizer.normalize with all names and return normalized result" do
      expect(Snippr::Normalizer).to receive(:normalize).with("a").and_return("AA")
      expect(Snippr::Normalizer).to receive(:normalize).with(:b).and_return("BB")
      subject.normalize_name("a", :b).should == "AA/BB"
    end

  end

  describe ".path_from_name" do

    before do
      subject.path = 'path'
    end

    it "joins path and name (with extension)" do
      subject.path_from_name('name', 'snip').should == 'path/name.snip'
    end

    it "joins path and name (without extension)" do
      subject.path_from_name('file').should == 'path/file'
    end

  end

  describe ".list" do

    context "without I18n" do

      before do
        Snippr::I18n.enabled = false
      end

      it "returns a list of all snippr names" do
        subject.list(:topup).should == [:some_error, :success]
      end

      it "returns an empty array for non existant dirs" do
        subject.list(:doesnotexist).should == []
      end

      it "can cope with umlauts in the name" do
        subject.list(:mixed_encoding).first.encoding.to_s.should == "UTF-8"
      end

    end

    context "with I18n" do

      before do
        Snippr::I18n.enabled = true
      end

      it "returns a list of all snippr names of the current locale (de)" do
        I18n.locale = :de
        subject.list(:i18n).should == [:list, :shop]
      end

      it "returns a list of all snippr names of the current locale (en)" do
        I18n.locale = :en
        subject.list(:i18n).should == [:shop]
      end

      it "returns an empty array for non existant dirs" do
        subject.list(:doesnotexist).should == []
      end

    end

  end

end
