# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Snip do

  describe "initializer" do

    before do
      Snippr::Path.path = 'path'
    end

    context "without I18n" do

      before do
        Snippr::I18n.enabled = false
      end

      it "calls #after_initialize" do
        expect_any_instance_of(Snippr::Snip).to receive(:after_initialize).once
        Snippr::Snip.new(:path_to_snips, :file)
      end

      it "initializes name, path and opts without opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file)
        expect(snip.name).to eq('pathToSnips/file')
        expect(snip.path).to eq('path/pathToSnips/file.snip')
        expect(snip.opts).to eq({})
      end

      it "initializes name, path and opts with opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :key => :value)
        expect(snip.name).to eq('pathToSnips/file')
        expect(snip.path).to eq('path/pathToSnips/file.snip')
        expect(snip.opts).to eq({:key => :value})
      end

      it "initializes name, path and opts with given extension" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :extension => :yml)
        expect(snip.name).to eq("pathToSnips/file")
        expect(snip.path).to eq("path/pathToSnips/file.yml")
        expect(snip.opts).to eq({ :extension => :yml })
      end

      it "initializes name, path and opts with given i18n deactivation" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :i18n => true)
        expect(snip.name).to eq("pathToSnips/file_#{::I18n.locale}")
        expect(snip.path).to eq("path/pathToSnips/file_#{::I18n.locale}.snip")
        expect(snip.opts).to eq({ :i18n => true })
      end

      it "returns no double slashes in the path for nil value" do
        snip = Snippr::Snip.new(:path_to_snips, nil ,:file)
        expect(snip.name).to eq('pathToSnips/file')
        expect(snip.path).to eq('path/pathToSnips/file.snip')
      end

      it "returns no double slahes in the path for empty string value" do
        snip = Snippr::Snip.new(:path_to_snips, "" ,:file)
        expect(snip.name).to eq('pathToSnips/file')
        expect(snip.path).to eq('path/pathToSnips/file.snip')
      end

    end

    context "with I18n" do

      before do
        Snippr::I18n.enabled = true
      end

      it "initializes name, path and opts without opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file)
        expect(snip.name).to eq("pathToSnips/file_#{::I18n.locale}")
        expect(snip.path).to eq("path/pathToSnips/file_#{::I18n.locale}.snip")
        expect(snip.opts).to eq({})
      end

      it "initializes name, path and opts with opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :key => :value)
        expect(snip.name).to eq("pathToSnips/file_#{::I18n.locale}")
        expect(snip.path).to eq("path/pathToSnips/file_#{::I18n.locale}.snip")
        expect(snip.opts).to eq({:key => :value})
      end

      it "initializes name, path and opts with given extension" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :extension => :yml)
        expect(snip.name).to eq("pathToSnips/file_#{::I18n.locale}")
        expect(snip.path).to eq("path/pathToSnips/file_#{::I18n.locale}.yml")
        expect(snip.opts).to eq({ :extension => :yml })
      end

      it "initializes name, path and opts with given i18n deactivation" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :i18n => false)
        expect(snip.name).to eq("pathToSnips/file")
        expect(snip.path).to eq("path/pathToSnips/file.snip")
        expect(snip.opts).to eq({ :i18n => false })
      end
    end


  end

  describe "#unprocessed_content" do

    it "reads an existing snip" do
      expect(Snippr::Snip.new(:home).unprocessed_content).to eq('<p>Home</p>')
    end

    it "stores the read data instead of reading it again" do
      expect(File).to receive(:read).once.and_return('data')
      snip = Snippr::Snip.new(:home)
      expect(snip.unprocessed_content).to eq('data')
      expect(snip.unprocessed_content).to eq('data')
    end

    it "returns an empty string on missing snips" do
      expect(File).to receive(:read).never
      expect(Snippr::Snip.new(:doesnotexist).unprocessed_content).to eq('')
    end

    it "strips the read content" do
      expect(Snippr::Snip.new(:empty).unprocessed_content).to eq('')
    end

  end

  describe "content" do

    it "calls Snippr::Processor.process with opts and return decorated result" do
      expect(Snippr::Processor).to receive(:process).with('<p>Home</p>', {:a => :b}, anything()).and_return('processed')
      expect(Snippr::Snip.new(:home, :a => :b).content).to eq("<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->")
    end

    it "stores the processed data instead of processing it again" do
      expect(Snippr::Processor).to receive(:process).with('<p>Home</p>', {:a => :b}, anything()).once.and_return('processed')
      snip = Snippr::Snip.new(:home, :a => :b)
      expect(snip.content).to eq("<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->")
      expect(snip.content).to eq("<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->")
    end

    it "doesn't call Snippr::Processor.process and return missing string" do
      expect(Snippr::Processor).to receive(:process).never
      expect(Snippr::Snip.new(:doesnotexist, :a => :b).content).to eq('<!-- missing snippr: doesnotexist -->')
    end

    it "removes the _include key from the metadata" do
      snip = Snippr::Snip.new(:include, :main)
      expect(snip.meta).to_not have_key("_include")
    end
  end

  describe "#missing?" do

    it "returns true when the snip isn't there" do
      expect(Snippr::Snip.new(:doesnotexist)).to be_missing
    end

    it "returns false when the snip is there but empty" do
      expect(Snippr::Snip.new(:empty)).not_to be_missing
    end

    it "returns false when the snip is there and has content" do
      expect(Snippr::Snip.new(:home)).not_to be_missing
    end

  end

  describe "#empty?" do

    it "returns true when the snip isn't there" do
      expect(Snippr::Snip.new(:doesnotexist)).to be_empty
    end

    it "returns false when the snip is there but empty" do
      expect(Snippr::Snip.new(:empty)).to be_empty
    end

    it "returns false when the snip is there and has content" do
      expect(Snippr::Snip.new(:home)).not_to be_empty
    end

  end

  describe '#meta' do
    it 'returns metadata from valid segment' do
      expect(Snippr::Snip.new(:meta, :with_content_and_segmentfilter).meta).to eq({'description' => 'neues meta'})
    end

    it 'initializes meta with empty hash' do
      expect(Snippr::Snip.new(:meta, :missing_snippet).meta).to eq({})
    end
  end

end
