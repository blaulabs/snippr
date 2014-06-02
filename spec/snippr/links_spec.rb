# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Links do

  describe "adjust_urls_except" do

    it "defaults to [/^#/, /^[a-z]+:/i]" do
      subject.adjust_urls_except = nil
      expect(subject.adjust_urls_except).to eq([/^#/, /^[a-z]+:/i])
    end

    it "stores exceptions" do
      subject.adjust_urls_except = [/^cms.*/]
      expect(subject.adjust_urls_except).to eq([/^cms.*/])
    end

  end

  describe ".adjust_link" do

    it "returns an a without href unchanged" do
      expect(subject.adjust_link('<a name="headline"/>')).to eq('<a name="headline"/>')
    end

    it "adjusts the href to the adjustd_url" do
      expect(subject).to receive(:adjust_url).with('url').and_return('adjustd_url')
      expect(subject.adjust_link('<a onclick="return true;" href="url" class="link">test</a>')).to eq('<a onclick="return true;" href="adjustd_url" class="link">test</a>')
    end

    it "adds an onclick when href starts with popup:" do
      expect(subject).to receive(:adjust_url).with('popup_url').and_return('adjustd_url')
      expect(subject.adjust_link('<a href="popup:popup_url" class="link">test</a>')).to eq('<a href="adjustd_url" class="link" onclick="if (typeof popup == \'undefined\') { return true; } else { popup(this); return false; }">test</a>')
    end

    it "replaces an existing onclick when href starts with popup:" do
      expect(subject).to receive(:adjust_url).with('url').and_return('adjustd_url')
      expect(subject.adjust_link('<a onclick="return true;" href="popup://url" class="link">test</a>')).to eq('<a onclick="if (typeof popup == \'undefined\') { return true; } else { popup(this); return false; }" href="adjustd_url" class="link">test</a>')
    end

  end

  describe ".adjust_url" do

    before do
      allow(subject).to receive(:relative_url_root).and_return('/root/')
    end

    it "leaves absolute links (http) as is" do
      expect(subject.adjust_url('http://www.blaulabs.de')).to eq('http://www.blaulabs.de')
    end

    it "leaves absolute links (https) as is" do
      expect(subject.adjust_url('https://www.blaulabs.de')).to eq('https://www.blaulabs.de')
    end

    it "leaves special links (mailto) as is" do
      expect(subject.adjust_url('mailto:info@blau.de')).to eq('mailto:info@blau.de')
    end

    it "converts relative links to server absolute links" do
      expect(subject.adjust_url('relative.html')).to eq('/root/relative.html')
    end

    it "converts app absolute links to server absolute links" do
      expect(subject.adjust_url('/absolute.html')).to eq('/root/absolute.html')
    end

    it "leaves internal links (#) as is" do
      expect(subject.adjust_url('#aname')).to eq('#aname')
    end

    it "converts links excepted in next test to server absolute links" do
      expect(subject.adjust_url('/cms/excepted.html')).to eq('/root/cms/excepted.html')
    end

    it "leaves server absolute links as is" do
      expect(subject.adjust_url('/root/bla/absolute.html')).to eq('/root/bla/absolute.html')
    end

    it "leaves excepted links as is" do
      subject.adjust_urls_except << /^\/cms\//
      expect(subject.adjust_url('/cms/excepted.html')).to eq('/cms/excepted.html')
    end

  end

  describe ".relative_url_root" do

    it "returns / without rails" do
      expect(subject.relative_url_root).to eq('/')
    end

    context "with rails" do

      before do
        module ::ActionController; class Base; end; end
      end

      after do
        Object.send :remove_const, :ActionController
      end

      it "returns / with relative_url_root set to nil" do
        allow(ActionController::Base).to receive(:config).and_return(double :relative_url_root => nil)
        expect(subject.relative_url_root).to eq('/')
      end

      it "returns / with relative_url_root set to empty string" do
        allow(ActionController::Base).to receive(:config).and_return(double :relative_url_root => '')
        expect(subject.relative_url_root).to eq('/')
      end

      it "returns / with relative_url_root set to /" do
        allow(ActionController::Base).to receive(:config).and_return(double :relative_url_root => '/')
        expect(subject.relative_url_root).to eq('/')
      end

      it "returns /root/ with relative_url_root set to root" do
        allow(ActionController::Base).to receive(:config).and_return(double :relative_url_root => 'root')
        expect(subject.relative_url_root).to eq('/root/')
      end

      it "returns /root/ with relative_url_root set to /root" do
        allow(ActionController::Base).to receive(:config).and_return(double :relative_url_root => '/root')
        expect(subject.relative_url_root).to eq('/root/')
      end

      it "returns /root/ with relative_url_root set to /root/" do
        allow(ActionController::Base).to receive(:config).and_return(double :relative_url_root => '/root/')
        expect(subject.relative_url_root).to eq('/root/')
      end

    end

  end

end
