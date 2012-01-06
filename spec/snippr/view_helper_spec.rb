# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::ViewHelper do
  include Snippr::ViewHelper

  describe "snippr" do

    def helper_method(param)
      "wrapppppp #{param.upcase} ppppppparw"
    end

    it "should allow calling of methods on a Rails view" do
      snippr(:with_view_helper_method).should == "<!-- starting snippr: withViewHelperMethod -->\nwith helper *wrapppppp TEST ppppppparw*\n<!-- closing snippr: withViewHelperMethod -->"
    end

    context "existance check on string returned by snippr" do

      context "existing snippet" do

        it "returns true when calling .exists?" do
          snippr(:home).exists?.should be_true
        end

        it "returns false when calling .missing?" do
          snippr(:home).missing?.should be_false
        end

      end

      context "missing snippet" do
        it "returns false when calling .exists?" do
          snippr(:missing).exists?.should be_false
        end

        it "returns true when calling .missing?" do
          snippr(:missing).missing?.should be_true
        end
      end

    end

    context "snippr with meta data" do

      context "and content" do

        it "returns a Hash of meta information" do
          snippr(:meta, :with_content).meta.should == {
            "description" => "Die mit dem Fluegli",
            "keywords" => "blau Mobilfunk GmbH, blau.de, blauworld, handy, sim"
          }
        end

        it "returns a hash ofmeta information even if the YAML Fron Matter BLock ends without newline" do
          snippr(:meta, :with_content_no_newline).meta.should == {
            "description" => "Die mit dem Fluegli",
            "keywords" => "blau Mobilfunk GmbH, blau.de, blauworld, handy, sim"
          }

        end

        it "accepts a key to search for" do
          snippr(:meta, :with_content).meta("description").should == "Die mit dem Fluegli"
        end

        it "returns the content without meta information" do
          snippr(:meta, :with_content).to_s.should == "<!-- starting snippr: meta/withContent -->\n<p>So meta!</p>\n<!-- closing snippr: meta/withContent -->"
        end

      end

      context "and no content" do

        it "still returns a Hash of meta information" do
          snippr(:meta, :with_no_content).meta.should == {
            "description" => "Die mit dem Fluegli",
            "keywords" => "blau Mobilfunk GmbH, blau.de, blauworld, handy, sim"
          }
        end

      end

    end

    context "snippr with broken meta data" do

      it "logs a warning and acts as if no meta information exist" do
        Snippr.logger.expects(:warn).with do |msg|
          msg =~ /Unable to extract meta data from Snip \[:meta, :broken\]/
        end

        snip = snippr(:meta, :broken)
        snip.meta.should == {}
        snip.to_s.should == "<!-- starting snippr: meta/broken -->\n<p>Broken!</p>\n<!-- closing snippr: meta/broken -->"
      end

    end

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

  describe "#snippr_with_path" do

    context "on pages controller (special case)" do

      before do
        stubs(:controller_name).returns("pages")
        stubs(:params).returns(:id => "a/path", :action => :view)
      end

      it "uses the path given in 'id' param" do
        snippr_with_path(:a_snippet).should == "<!-- starting snippr: a/path/aSnippet -->\na snippet\n<!-- closing snippr: a/path/aSnippet -->"
      end

      it "works with a given block" do
        lambda {
          snippr_with_path(:a_snippet) do |snippr|
            snippr.should be_html_safe
            raise StandardError.new('block should be called')
          end
        }.should raise_error StandardError, 'block should be called'
      end

      it "works with parameters hash" do
        snippr_with_path(:a_snippet_with_param, :param => "value").should == "<!-- starting snippr: a/path/aSnippetWithParam -->\na snippet with param value\n<!-- closing snippr: a/path/aSnippetWithParam -->"
      end

    end

    context "on standard controllers" do

      before do
        stubs(:controller_name).returns("with_underscore")
        stubs(:params).returns(:action => :and_underscore)
      end

      it "should camelize controller and action names" do
        snippr_with_path(:a_snippet).should == "<!-- starting snippr: withUnderscore/andUnderscore/aSnippet -->\nan underscored snippet with param {param}\n<!-- closing snippr: withUnderscore/andUnderscore/aSnippet -->"
      end

      it "works with a given block" do
        lambda {
          snippr_with_path(:a_snippet) do |snippr|
            snippr.should be_html_safe
            raise StandardError.new('block should be called')
          end
        }.should raise_error StandardError, 'block should be called'
      end

      it "works with parameters hash" do
        snippr_with_path(:a_snippet, :param => "value").should == "<!-- starting snippr: withUnderscore/andUnderscore/aSnippet -->\nan underscored snippet with param value\n<!-- closing snippr: withUnderscore/andUnderscore/aSnippet -->"
      end

      it "should allow multiple arguments" do
        snippr_with_path(:deeper, :nested, :snippet).should == "<!-- missing snippr: withUnderscore/andUnderscore/deeper/nested/snippet -->"
      end
    end

  end

end
