# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Path do

  describe "path" do

    before do
      subject.path = nil
    end

    it "stores the path if set as string" do
      expect(subject.path).to eq('')
      subject.path = 'path'
      expect(subject.path).to eq('path')
    end

    it "stores and defers the path evaluation if passed a lambda" do
      subject.path = lambda { "WOW LAMBDA ACTION!" }
      expect(subject.path).to eq("WOW LAMBDA ACTION!")
    end

  end

  describe ".normalize_name" do

    it "calls Snippr::Normalizer.normalize with all names and return normalized result" do
      expect(Snippr::Normalizer).to receive(:normalize).with("a").and_return("AA")
      expect(Snippr::Normalizer).to receive(:normalize).with(:b).and_return("BB")
      expect(subject.normalize_name("a", :b)).to eq("AA/BB")
    end

  end

  describe ".path_from_name" do

    before do
      subject.path = 'path'
    end

    it "joins path and name (with extension)" do
      expect(subject.path_from_name('name', 'snip')).to eq('path/name.snip')
    end

    it "joins path and name (without extension)" do
      expect(subject.path_from_name('file')).to eq('path/file')
    end

  end

  describe ".list" do

    context "without I18n" do

      before do
        Snippr::I18n.enabled = false
      end

      it "returns a list of all snippr names" do
        expect(subject.list(:topup)).to eq([:some_error, :success])
      end

      it "returns an empty array for non existant dirs" do
        expect(subject.list(:doesnotexist)).to eq([])
      end

    end

    context "with I18n" do

      before do
        Snippr::I18n.enabled = true
      end

      it "returns a list of all snippr names of the current locale (de)" do
        I18n.locale = :de
        expect(subject.list(:i18n)).to eq([:list, :shop])
      end

      it "returns a list of all snippr names of the current locale (en)" do
        I18n.locale = :en
        expect(subject.list(:i18n)).to eq([:shop])
      end

      it "returns an empty array for non existant dirs" do
        expect(subject.list(:doesnotexist)).to eq([])
      end

    end

  end

end
