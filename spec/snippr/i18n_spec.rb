require "spec_helper"

describe Snippr::I18n do

  describe "enabled" do

    it "should store the enabled state" do
      subject.enabled = nil
      subject.enabled?.should == false
      subject.enabled = true
      subject.enabled?.should == true
    end

  end

  describe "locale" do

    it "should return an empty string when I18n is not enabled" do
      subject.enabled = false
      subject.locale.should == ''
    end

    it "should return the locale string when I18n is enabled" do
      subject.enabled = true
      subject.locale.should == "_#{I18n.locale}"
    end

  end

end
