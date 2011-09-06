require "spec_helper"

describe Snippr::Links do

  describe "adjust_urls_except" do

    it "should default to [/^#/, /^[a-z]+:/i]" do
      subject.adjust_urls_except = nil
      subject.adjust_urls_except.should == [/^#/, /^[a-z]+:/i]
    end

    it "should store exceptions" do
      subject.adjust_urls_except = [/^cms.*/]
      subject.adjust_urls_except.should == [/^cms.*/]
    end

  end

  describe ".adjust_link" do

    it "should return an a without href unchanged" do
      subject.adjust_link('<a name="headline"/>').should == '<a name="headline"/>'
    end

    it "should adjust the href to the adjustd_url" do
      subject.expects(:adjust_url).with('url').returns('adjustd_url')
      subject.adjust_link('<a onclick="return true;" href="url" class="link">test</a>').should == '<a onclick="return true;" href="adjustd_url" class="link">test</a>'
    end

    it "should add an onclick when href starts with popup:" do
      subject.expects(:adjust_url).with('popup_url').returns('adjustd_url')
      subject.adjust_link('<a href="popup:popup_url" class="link">test</a>').should == '<a href="adjustd_url" class="link" onclick="if (typeof popup == \'undefined\') { return true; } else { popup(this); return false; }">test</a>'
    end

    it "should replace an existing onclick when href starts with popup:" do
      subject.expects(:adjust_url).with('url').returns('adjustd_url')
      subject.adjust_link('<a onclick="return true;" href="popup://url" class="link">test</a>').should == '<a onclick="if (typeof popup == \'undefined\') { return true; } else { popup(this); return false; }" href="adjustd_url" class="link">test</a>'
    end

  end

  describe ".adjust_url" do

    before do
      subject.stubs(:relative_url_root).returns('/root/')
    end

    it "should leave absolute links (http) as is" do
      subject.adjust_url('http://www.blaulabs.de').should == 'http://www.blaulabs.de'
    end

    it "should leave absolute links (https) as is" do
      subject.adjust_url('https://www.blaulabs.de').should == 'https://www.blaulabs.de'
    end

    it "should leave special links (mailto) as is" do
      subject.adjust_url('mailto:info@blau.de').should == 'mailto:info@blau.de'
    end

    it "should convert relative links to server absolute links" do
      subject.adjust_url('relative.html').should == '/root/relative.html'
    end

    it "should convert app absolute links to server absolute links" do
      subject.adjust_url('/absolute.html').should == '/root/absolute.html'
    end

    it "should leave internal links (#) as is" do
      subject.adjust_url('#aname').should == '#aname'
    end

    it "should convert links excepted in next test to server absolute links" do
      subject.adjust_url('/cms/excepted.html').should == '/root/cms/excepted.html'
    end

    it "should leave server absolute links as is" do
      subject.adjust_url('/root/bla/absolute.html').should == '/root/bla/absolute.html'
    end

    it "should leave excepted links as is" do
      subject.adjust_urls_except << /^\/cms\//
      subject.adjust_url('/cms/excepted.html').should == '/cms/excepted.html'
    end

  end

  describe ".relative_url_root" do

    it "should return / without rails" do
      subject.relative_url_root.should == '/'
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
        subject.relative_url_root.should == '/'
      end

      it "should return / with relative_url_root set to empty string" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '')
        subject.relative_url_root.should == '/'
      end

      it "should return / with relative_url_root set to /" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '/')
        subject.relative_url_root.should == '/'
      end

      it "should return /root/ with relative_url_root set to root" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => 'root')
        subject.relative_url_root.should == '/root/'
      end

      it "should return /root/ with relative_url_root set to /root" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '/root')
        subject.relative_url_root.should == '/root/'
      end

      it "should return /root/ with relative_url_root set to /root/" do
        ActionController::Base.stubs(:config).returns(stub :relative_url_root => '/root/')
        subject.relative_url_root.should == '/root/'
      end

    end

  end

end
