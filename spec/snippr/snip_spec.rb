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

      it "should initialize name, path and opts without opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file)
        snip.name.should == 'pathToSnips/file'
        snip.path.should == 'path/pathToSnips/file.snip'
        snip.opts.should == {}
      end

      it "should initialize name, path and opts with opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :key => :value)
        snip.name.should == 'pathToSnips/file'
        snip.path.should == 'path/pathToSnips/file.snip'
        snip.opts.should == {:key => :value}
      end

      it "should initialize name, path and opts with given extension" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :extension => :yml)
        snip.name.should == "pathToSnips/file"
        snip.path.should == "path/pathToSnips/file.yml"
        snip.opts.should == { :extension => :yml }
      end
      
      it "should initialize name, path and opts with given i18n deactivation" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :i18n => true)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.snip"
        snip.opts.should == { :i18n => true }
      end
      
    end

    context "with I18n" do

      before do
        Snippr::I18n.enabled = true
      end

      it "should initialize name, path and opts without opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.snip"
        snip.opts.should == {}
      end

      it "should initialize name, path and opts with opts" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :key => :value)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.snip"
        snip.opts.should == {:key => :value}
      end

      it "should initialize name, path and opts with given extension" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :extension => :yml)
        snip.name.should == "pathToSnips/file_#{::I18n.locale}"
        snip.path.should == "path/pathToSnips/file_#{::I18n.locale}.yml"
        snip.opts.should == { :extension => :yml }
      end
    
      it "should initialize name, path and opts with given i18n deactivation" do
        snip = Snippr::Snip.new(:path_to_snips, :file, :i18n => false)
        snip.name.should == "pathToSnips/file"
        snip.path.should == "path/pathToSnips/file.snip"
        snip.opts.should == { :i18n => false }
      end
    end
    

  end

  describe "#unprocessed_content" do

    it "should read an existing snip" do
      Snippr::Snip.new(:home).unprocessed_content.should == '<p>Home</p>'
    end

    it "should store the read data instead of reading it again" do
      File.expects(:read).once.returns('data')
      snip = Snippr::Snip.new(:home)
      snip.unprocessed_content.should == 'data'
      snip.unprocessed_content.should == 'data'
    end

    it "should return an empty string on missing snips" do
      File.expects(:read).never
      Snippr::Snip.new(:doesnotexist).unprocessed_content.should == ''
    end

    it "should strip the read content" do
      Snippr::Snip.new(:empty).unprocessed_content.should == ''
    end

  end

  [:content, :to_s].each do |method|

    describe "##{method}" do

      it "should call Snippr::Processor.process with opts and return decorated result" do
        Snippr::Processor.expects(:process).with('<p>Home</p>', {:a => :b}).returns('processed')
        Snippr::Snip.new(:home, :a => :b).send(method).should == "<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->"
      end

      it "should store the processed data instead of processing it again" do
        Snippr::Processor.expects(:process).with('<p>Home</p>', {:a => :b}).once.returns('processed')
        snip = Snippr::Snip.new(:home, :a => :b)
        snip.send(method).should == "<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->"
        snip.send(method).should == "<!-- starting snippr: home -->\nprocessed\n<!-- closing snippr: home -->"
      end

      it "should not call Snippr::Processor.process and return missing string" do
        Snippr::Processor.expects(:process).never
        Snippr::Snip.new(:doesnotexist, :a => :b).send(method).should == '<!-- missing snippr: doesnotexist -->'
      end

    end

  end

  describe "#missing?" do

    it "should return true when the snip isn't there" do
      Snippr::Snip.new(:doesnotexist).should be_missing
    end

    it "should return false when the snip is there but empty" do
      Snippr::Snip.new(:empty).should_not be_missing
    end

    it "should return false when the snip is there and has content" do
      Snippr::Snip.new(:home).should_not be_missing
    end

  end

  describe "#empty?" do

    it "should return true when the snip isn't there" do
      Snippr::Snip.new(:doesnotexist).should be_empty
    end

    it "should return false when the snip is there but empty" do
      Snippr::Snip.new(:empty).should be_empty
    end

    it "should return false when the snip is there and has content" do
      Snippr::Snip.new(:home).should_not be_empty
    end

  end

end
