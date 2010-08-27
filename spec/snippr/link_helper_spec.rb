require "spec_helper"

describe Snippr::LinkHelper do

  include Snippr::LinkHelper

  describe "#enhance_link" do

    it "should return an a without href unchanged" do
      enhance_link('<a name="headline"/>').should == '<a name="headline"/>'
    end

    it "should adjust the href to the enhanced_url" do
      expects(:enhance_url).with('url').returns('enhanced_url')
      enhance_link('<a onclick="return true;" href="url" class="link">test</a>').should == '<a onclick="return true;" href="enhanced_url" class="link">test</a>'
    end

    it "should add an onclick when href starts with popup:" do
      expects(:enhance_url).with('popup_url').returns('enhanced_url')
      enhance_link('<a href="popup:popup_url" class="link">test</a>').should == '<a href="enhanced_url" class="link" onclick="if (typeof popup == \'undefined\') { return true; } else { popup(\'enhanced_url\'); return false; }">test</a>'
    end

    it "should replace an existing onclick when href starts with popup:" do
      expects(:enhance_url).with('url').returns('enhanced_url')
      enhance_link('<a onclick="return true;" href="popup://url" class="link">test</a>').should == '<a onclick="if (typeof popup == \'undefined\') { return true; } else { popup(\'enhanced_url\'); return false; }" href="enhanced_url" class="link">test</a>'
    end

  end

  describe "#enhance_url" do

    before do
      stubs(:relative_url_root).returns('/root/')
    end

    it "should leave absolute links (http) as is" do
      enhance_url('http://www.blaulabs.de').should == 'http://www.blaulabs.de'
    end

    it "should leave absolute links (https) as is" do
      enhance_url('https://www.blaulabs.de').should == 'https://www.blaulabs.de'
    end

    it "should leave special links (mailto) as is" do
      enhance_url('mailto:info@blau.de').should == 'mailto:info@blau.de'
    end

    it "should convert relative links to absolute links" do
      enhance_url('relative.html').should == '/root/relative.html'
    end

    it "should leave server absolute links as is" do
      enhance_url('/absolute.html').should == '/root/absolute.html'
    end

  end

  describe "#relative_url_root" do

    it "should return / without rails" do
      relative_url_root.should == '/'
    end

    context "with rails" do

      before do
        module ::ActionController; class Base; end; end
      end

      after do
        Object.send :remove_const, :ActionController
      end

      it "should return / with relative_url_root set to nil" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => nil)
        relative_url_root.should == '/'
      end

      it "should return / with relative_url_root set to empty string" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '')
        relative_url_root.should == '/'
      end

      it "should return / with relative_url_root set to /" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '/')
        relative_url_root.should == '/'
      end

      it "should return /root/ with relative_url_root set to root" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => 'root')
        relative_url_root.should == '/root/'
      end

      it "should return /root/ with relative_url_root set to /root" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '/root')
        relative_url_root.should == '/root/'
      end

      it "should return /root/ with relative_url_root set to /root/" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '/root/')
        relative_url_root.should == '/root/'
      end

    end

  end

end
