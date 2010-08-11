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
      end

      it "should work when html_safe is not available" do
        @string.should_not respond_to(:html_safe)
        @helper.snippr('home').should == @string
      end

      it "should call html_safe when it is available" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        @helper.snippr('home').should == 'html_safe_snippr'
      end
      
      it "should pass snippr to block and return returned value" do
        @helper.snippr('home') do |s|
          s.should == @string
          'modified'
        end.should == 'modified'
      end

    end

    context "empty snippr" do

      before do
        @string = "   \n\n  \n"
        Snippr.expects(:load).with('home').returns(@string)
        @string.stubs(:missing_snippr?).returns(false)
      end

      it "should work when html_safe is not available" do
        @string.should_not respond_to(:html_safe)
        @helper.snippr('home').should == @string
      end

      it "should call html_safe when it is available" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        @helper.snippr('home').should == 'html_safe_snippr'
      end
      
      it "should not pass snippr to block and return original value" do
        @helper.snippr('home') do |s|
          s.should == @string
          'modified'
        end.should == @string
      end

    end

    context "missing snippr" do

      before do
        @string = 'missing'
        Snippr.expects(:load).with('home').returns(@string)
        @string.stubs(:missing_snippr?).returns(true)
      end

      it "should work when html_safe is not available" do
        @string.should_not respond_to(:html_safe)
        @helper.snippr('home').should == @string
      end

      it "should call html_safe when it is available" do
        @string.expects(:html_safe).returns('html_safe_snippr')
        @helper.snippr('home').should == 'html_safe_snippr'
      end
      
      it "should not pass snippr to block and return original value" do
        @helper.snippr('home') do |s|
          s.should == @string
          'modified'
        end.should == @string
      end

    end

  end

end
