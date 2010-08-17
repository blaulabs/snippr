require "spec_helper"

describe Snippr::Helper do

  describe "snippr" do

    before do
      @helper = Class.new do
        include Snippr::Helper
      end.new
    end

    context "existing snippr" do

      before do
        @string = 'content'
        Snippr.expects(:load).with('home').returns(@string)
        @string.stubs(:missing_snippr?).returns(false)
        @string.stubs(:empty_snippr?).returns(false)
      end

      it "should call html_safe and return html save value" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        @helper.snippr('home').should == 'html_safe_snippr'
      end

      it "should pass html_safe snippr to block" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        lambda {
          @helper.snippr('home') do |snippr|
            snippr.should == 'html_safe_snippr'
            raise StandardError.new('block should be called')
          end
        }.should raise_error StandardError, 'block should be called'
      end

      it "should return 0 with block" do
        @helper.snippr('home') do; end.should == 0
      end

    end

    context "empty snippr" do

      before do
        @string = "   \n\n  \n"
        Snippr.expects(:load).with('home').returns(@string)
        @string.stubs(:missing_snippr?).returns(false)
        @string.stubs(:empty_snippr?).returns(true)
      end

      it "should call html_safe return html save value" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        @helper.snippr('home').should == 'html_safe_snippr'
      end

      it "should not pass snippr to block but concat snippr and return 0" do
        @helper.expects(:concat).with(@string)
        lambda {
          @helper.snippr('home') do
            raise StandardError.new('block should not be called')
          end.should == 0
        }.should_not raise_error
      end

    end

    context "missing snippr" do

      before do
        @string = 'missing'
        Snippr.expects(:load).with('home').returns(@string)
        @string.stubs(:missing_snippr?).returns(true)
        @string.stubs(:empty_snippr?).returns(true)
      end

      it "should call html_safe return html save value" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        @helper.snippr('home').should == 'html_safe_snippr'
      end

      it "should not pass snippr to block but concat snippr and return 0" do
        @helper.expects(:concat).with(@string)
        lambda {
          @helper.snippr('home') do
            raise StandardError.new('block should not be called')
          end.should == 0
        }.should_not raise_error
      end

    end

  end

end
