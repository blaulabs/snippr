require "spec_helper"

describe Snippr::Path do

  describe "path" do

    it "should store the path" do
      Snippr::Path.path = nil
      Snippr::Path.path.should == ''
      Snippr::Path.path = 'path'
      Snippr::Path.path.should == 'path'
    end

    # TODO test JVM path? [thomas, 2010-08-26]

  end

  describe ".normalize_name" do

    it "should call Snippr::Normalizer.normalize with all names and return normalized result" do
      seq = sequence "normalizers"
      Snippr::Normalizer.expects(:normalize).with("a").in_sequence(seq).returns("AA")
      Snippr::Normalizer.expects(:normalize).with(:b).in_sequence(seq).returns("BB")
      Snippr::Path.normalize_name("a", :b).should == "AA/BB"
    end

  end

  describe ".path_from_name" do

    before do
      Snippr::Path.path = 'path'
    end

    it "should join path and name (with extension)" do
      Snippr::Path.path_from_name('name', 'snip').should == 'path/name.snip'
    end

    it "should join path and name (without extension)" do
      Snippr::Path.path_from_name('file').should == 'path/file'
    end

  end

  describe ".list" do

    context "without I18n" do

      before do
        Snippr::I18n.enabled = false
      end

      it "should return a list of all snippr names" do
        Snippr::Path.list(:topup).should == [:some_error, :success]
      end

      it "should return an empty array for non existant dirs" do
        Snippr::Path.list(:doesnotexist).should == []
      end

    end

    context "with I18n" do

      before do
        Snippr::I18n.enabled = true
      end

      it "should return a list of all snippr names of the current locale (de)" do
        I18n.locale = :de
        Snippr::Path.list(:i18n).should == [:list, :shop]
      end

      it "should return a list of all snippr names of the current locale (en)" do
        I18n.locale = :en
        Snippr::Path.list(:i18n).should == [:shop]
      end

      it "should return an empty array for non existant dirs" do
        Snippr::Path.list(:doesnotexist).should == []
      end

    end

  end

end
