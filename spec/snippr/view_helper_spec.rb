# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::ViewHelper do
  include Snippr::ViewHelper

  describe "snippr" do

    def helper_method(param)
      "wrapppppp #{param.upcase} ppppppparw"
    end

    def with_block(param1, block_content)
      "block result: #{block_content}"
    end

    it "allows calling of methods on a Rails view" do
      expect(snippr(:with_view_helper_method)).to eq("<!-- starting snippr: withViewHelperMethod -->\nwith helper *wrapppppp TEST ppppppparw*\n<!-- closing snippr: withViewHelperMethod -->")
    end

    context "block given in snippet" do
      it "returns a correct snippet" do
        expect(snippr(:with_block)).to eq("<!-- starting snippr: withBlock -->\nblock result: IN BLOCK-LINE \"TWO\"\n<!-- closing snippr: withBlock -->")
      end
    end

    context "existance check on string returned by snippr" do

      context "existing snippet" do

        it "returns true when calling .exists?" do
          expect(snippr(:home).exists?).to be_true
        end

        it "returns false when calling .missing?" do
          expect(snippr(:home).missing?).to be_false
        end

      end

      context "missing snippet" do
        it "returns false when calling .exists?" do
          expect(snippr(:missing).exists?).to be_false
        end

        it "returns true when calling .missing?" do
          expect(snippr(:missing).missing?).to be_true
        end
      end

    end

    context "snippr with meta data" do
      context "and content" do
        it "returns a Hash of meta information" do
          expect(snippr(:meta, :with_content).meta).to eq({
              "description" => "Die mit dem Fluegli",
              "keywords"    => "blau Mobilfunk GmbH, blau.de, blauworld, handy, sim"
          })
        end

        it "returns a hash ofmeta information even if the YAML Fron Matter BLock ends without newline" do
          expect(snippr(:meta, :with_content_no_newline).meta).to eq({
              "description" => "Die mit dem Fluegli",
              "keywords"    => "blau Mobilfunk GmbH, blau.de, blauworld, handy, sim"
          })
        end

        it "accepts a key to search for" do
          expect(snippr(:meta, :with_content).meta("description")).to eq("Die mit dem Fluegli")
        end

        it "returns the content without meta information" do
          expect(snippr(:meta, :with_content).to_s).to eq("<!-- starting snippr: meta/withContent -->\n<p>So meta!</p>\n<!-- closing snippr: meta/withContent -->")
        end
      end

      context "and no content" do
        it "still returns a Hash of meta information" do
          expect(snippr(:meta, :with_no_content).meta).to eq({
              "description" => "Die mit dem Fluegli",
              "keywords"    => "blau Mobilfunk GmbH, blau.de, blauworld, handy, sim"
          })
        end
      end

      context 'with segmentfilter' do
        it 'uses new meta data and new content' do
          # snippr(:meta, :with_content).to_s.should == "<!-- starting snippr: meta/withContentandSegmentfilter -->\n<p>So meta!</p>\n<!-- closing snippr: meta/withContentandSegmentfilter -->"
          expect(snippr(:meta, :with_content_and_segmentfilter).to_s).to eq "<!-- starting snippr: meta/withContentAndSegmentfilter -->\n<p>neuer content</p>\n<!-- closing snippr: meta/withContentAndSegmentfilter -->"
          expect(snippr(:meta, :with_content_and_segmentfilter).meta('description')).to eq 'neues meta'
        end
      end
    end

    context "snippr with broken meta data" do
      it "logs a warning and acts as if no meta information exist" do
        expect(Snippr.logger).to receive(:warn).with(/Unable to extract meta data from Snip \"meta\/broken\"/)

        snip = snippr(:meta, :broken)
        expect(snip.meta).to eq({})
        expect(snip.to_s).to eq("<!-- starting snippr: meta/broken -->\n<p>Broken!</p>\n<!-- closing snippr: meta/broken -->")
      end
    end

    context "existing snippr" do
      it "calls html_safe and return html safe value" do
        content = snippr(:home)
        expect(content).to eq("<!-- starting snippr: home -->\n<p>Home</p>\n<!-- closing snippr: home -->")
        expect(content).to be_html_safe
      end

      it "passes html_safe snippr to block" do
        expect {
          snippr(:home) do |snippr|
            expect(snippr).to be_html_safe
            raise StandardError.new('block should be called')
          end
        }.to raise_error StandardError, 'block should be called'
      end

      it "returns 0 with block" do
        expect(snippr(:home) do
          ;
        end).to eq(0)
      end

    end

    context "empty snippr" do

      it "calls html_safe return html save value" do
        content = snippr(:empty)
        expect(content).to eq("<!-- starting snippr: empty -->\n\n<!-- closing snippr: empty -->")
        expect(content).to be_html_safe
      end

      it "doesn't pass snippr to block but concat snippr and return 0" do
        expect(self).to receive(:concat).with("<!-- starting snippr: empty -->\n\n<!-- closing snippr: empty -->")
        expect {
          expect(snippr(:empty) do
            raise StandardError.new('block should not be called')
          end).to eq(0)
        }.not_to raise_error
      end

    end

    context "missing snippr" do

      it "calls html_safe return html save value" do
        content = snippr(:doesnotexist)
        expect(content).to eq('<!-- missing snippr: doesnotexist -->')
        expect(content).to be_html_safe
      end

      it "doesn't pass snippr to block but concat snippr and return 0" do
        expect(self).to receive(:concat).with('<!-- missing snippr: doesnotexist -->')
        expect {
          expect(snippr(:doesnotexist) do
            raise StandardError.new('block should not be called')
          end).to eq(0)
        }.not_to raise_error
      end

    end

  end

  describe "#snippr_with_path" do

    context "on pages controller (special case)" do

      before do
        allow(self).to receive(:controller_name).and_return("pages")
        allow(self).to receive(:params).and_return(:id => "a/path", :action => :view)
      end

      it "uses the path given in 'id' param" do
        expect(snippr_with_path(:a_snippet)).to eq("<!-- starting snippr: a/path/aSnippet -->\na snippet\n<!-- closing snippr: a/path/aSnippet -->")
      end

      it "works with a given block" do
        expect {
          snippr_with_path(:a_snippet) do |snippr|
            expect(snippr).to be_html_safe
            raise StandardError.new('block should be called')
          end
        }.to raise_error StandardError, 'block should be called'
      end

      it "works with parameters hash" do
        expect(snippr_with_path(:a_snippet_with_param, :param => "value")).to eq("<!-- starting snippr: a/path/aSnippetWithParam -->\na snippet with param value\n<!-- closing snippr: a/path/aSnippetWithParam -->")
      end

    end

    context "on standard controllers" do

      before do
        allow(self).to receive(:controller_name).and_return("with_underscore")
        allow(self).to receive(:params).and_return(:action => :and_underscore)
      end

      it "camelizes controller and action names" do
        expect(snippr_with_path(:a_snippet)).to eq("<!-- starting snippr: withUnderscore/andUnderscore/aSnippet -->\nan underscored snippet with param {param}\n<!-- closing snippr: withUnderscore/andUnderscore/aSnippet -->")
      end

      it "works with a given block" do
        expect {
          snippr_with_path(:a_snippet) do |snippr|
            expect(snippr).to be_html_safe
            raise StandardError.new('block should be called')
          end
        }.to raise_error StandardError, 'block should be called'
      end

      it "works with parameters hash" do
        expect(snippr_with_path(:a_snippet, :param => "value")).to eq("<!-- starting snippr: withUnderscore/andUnderscore/aSnippet -->\nan underscored snippet with param value\n<!-- closing snippr: withUnderscore/andUnderscore/aSnippet -->")
      end

      it "allows multiple arguments" do
        expect(snippr_with_path(:deeper, :nested, :snippet)).to eq("<!-- missing snippr: withUnderscore/andUnderscore/deeper/nested/snippet -->")
      end
    end
  end
end
