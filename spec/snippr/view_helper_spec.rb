require "spec_helper"

describe Snippr::ViewHelper do

  include Snippr::ViewHelper

  describe "snippr" do

    context "existing snippr" do

      it "should call html_safe and return html safe value" do
        content = snippr(:home)
        content.should == "<!-- starting snippr: home -->\n<p>Home</p>\n<!-- closing snippr: home -->"
        content.should be_html_safe
      end

      it "should pass html_safe snippr to block" do
        lambda {
          snippr(:home) do |snippr|
            snippr.should be_html_safe
            raise StandardError.new('block should be called')
          end
        }.should raise_error StandardError, 'block should be called'
      end

      it "should return 0 with block" do
        snippr(:home) do; end.should == 0
      end

    end

    context "empty snippr" do

      it "should call html_safe return html save value" do
        content = snippr(:empty)
        content.should == "<!-- starting snippr: empty -->\n\n<!-- closing snippr: empty -->"
        content.should be_html_safe
      end

      it "should not pass snippr to block but concat snippr and return 0" do
        expects(:concat).with("<!-- starting snippr: empty -->\n\n<!-- closing snippr: empty -->")
        lambda {
          snippr(:empty) do
            raise StandardError.new('block should not be called')
          end.should == 0
        }.should_not raise_error
      end

    end

    context "missing snippr" do

      it "should call html_safe return html save value" do
        content = snippr(:doesnotexist)
        content.should == '<!-- missing snippr: doesnotexist -->'
        content.should be_html_safe
      end

      it "should not pass snippr to block but concat snippr and return 0" do
        expects(:concat).with('<!-- missing snippr: doesnotexist -->')
        lambda {
          snippr(:doesnotexist) do
            raise StandardError.new('block should not be called')
          end.should == 0
        }.should_not raise_error
      end

    end

  end

end
