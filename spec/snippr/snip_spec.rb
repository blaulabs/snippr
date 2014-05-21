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
        Snippr::Snip.any_instance.should_receive(:after_initialize).once
        Snippr::Snip.new(:path_to_snips, :file)
      end

      it "initializes name, path and opts without opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file)
        snip.name.should == 'pathToSnips/file'
        snip.path.should == 'path/pathToSnips/file.snip'
        snip.opts.should == {}
      end

      it "initializes name, path and opts with opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :key => :value)
        snip.name.should == 'pathToSnips/file'
        snip.path.should == 'path/pathToSnips/file.snip'
        snip.opts.should == {:key => :value}
      end

      it "initializes name, path and opts with given extension" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :extension => :yml)
        snip.name.should == "pathToSnips/file"
        snip.path.should == "path/pathToSnips/file.yml"
        snip.opts.should == { :extension => :yml }
      end

      it "initializes name, path and opts with given i18n deactivation" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :i18n => true)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.snip"
        snip.opts.should == { :i18n => true }
      end

      it "returns no double slashes in the path for nil value" do
        snip = Snippr::Snip.new(:path_to_snips, nil ,:file)
        snip.name.should == 'pathToSnips/file'
        snip.path.should == 'path/pathToSnips/file.snip'
      end

      it "returns no double slahes in the path for empty string value" do
        snip = Snippr::Snip.new(:path_to_snips, "" ,:file)
        snip.name.should == 'pathToSnips/file'
        snip.path.should == 'path/pathToSnips/file.snip'
      end

    end

    context "with I18n" do

      before do
        Snippr::I18n.enabled = true
      end

      it "initializes name, path and opts without opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.snip"
        snip.opts.should == {}
      end

      it "initializes name, path and opts with opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :key => :value)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.snip"
        snip.opts.should == {:key => :value}
      end

      it "initializes name, path and opts with given extension" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :extension => :yml)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.yml"
        snip.opts.should == { :extension => :yml }
      end

      it "initializes name, path and opts with given i18n deactivation" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :i18n => false)
        snip.name.should == "pathToSnips/file"
        snip.path.should == "path/pathToSnips/file.snip"
        snip.opts.should == { :i18n => false }
      end
    end


  end

  describe "#unprocessed_content" do

    it "reads an existing snip" do
      Snippr::Snip.new(:home).unprocessed_content.should == '<p>Home</p>'
    end

    it "stores the read data instead of reading it again" do
      File.should_receive(:read).once.and_return('data')
      snip = Snippr::Snip.new(:home)
      snip.unprocessed_content.should == 'data'
      snip.unprocessed_content.should == 'data'
    end

    it "returns an empty string on missing snips" do
      File.should_receive(:read).never
      Snippr::Snip.new(:doesnotexist).unprocessed_content.should == ''
    end

    it "strips the read content" do
      Snippr::Snip.new(:empty).unprocessed_content.should == ''
    end

  end

  describe "content" do

    it "calls Snippr::Processor.process with opts and return decorated result" do
      Snippr::Processor.should_receive(:process).with('<p>Home</p>', {:a => :b}).and_return('processed')
      Snippr::Snip.new(:home, :a => :b).content.should == "<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->"
    end

    it "stores the processed data instead of processing it again" do
      Snippr::Processor.should_receive(:process).with('<p>Home</p>', {:a => :b}).once.and_return('processed')
      snip = Snippr::Snip.new(:home, :a => :b)
      snip.content.should == "<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->"
      snip.content.should == "<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->"
    end

    it "doesn't call Snippr::Processor.process and return missing string" do
      Snippr::Processor.should_receive(:process).never
      Snippr::Snip.new(:doesnotexist, :a => :b).content.should == '<!-- missing snippr: doesnotexist -->'
    end
  end

  describe "#missing?" do

    it "returns true when the snip isn't there" do
      Snippr::Snip.new(:doesnotexist).should be_missing
    end

    it "returns false when the snip is there but empty" do
      Snippr::Snip.new(:empty).should_not be_missing
    end

    it "returns false when the snip is there and has content" do
      Snippr::Snip.new(:home).should_not be_missing
    end

  end

  describe "#empty?" do

    it "returns true when the snip isn't there" do
      Snippr::Snip.new(:doesnotexist).should be_empty
    end

    it "returns false when the snip is there but empty" do
      Snippr::Snip.new(:empty).should be_empty
    end

    it "returns false when the snip is there and has content" do
      Snippr::Snip.new(:home).should_not be_empty
    end

  end

  describe '#meta' do
    it 'returns metadata from valid segment' do
      expect(Snippr::Snip.new(:meta, :with_content_and_segmentfilter).meta).to eq({'description' => 'neues meta'})
    end
  end

end
