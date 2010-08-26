require "spec_helper"

describe Snippr::I18n do

  describe "enabled" do

    it "should store the enabled state" do
      Snippr::I18n.enabled = nil
      Snippr::I18n.enabled?.should == false
      Snippr::I18n.enabled = true
      Snippr::I18n.enabled?.should == true
    end

  end

  describe "locale" do

    it "should return an empty string when I18n is not enabled" do
      Snippr::I18n.enabled = false
      Snippr::I18n.locale.should == ''
    end

    it "should return the locale string when I18n is enabled" do
      Snippr::I18n.enabled = true
      Snippr::I18n.locale.should == "_#{I18n.locale}"
    end

  end

end
