require "spec_helper"

describe Snippr::I18n do

  describe "enabled" do

    it "should store the enabled state" do
      subject.enabled = nil
      expect(subject.enabled?).to eq(false)
      subject.enabled = true
      expect(subject.enabled?).to eq(true)
    end

  end

  describe "locale" do

    it "should return an empty string when I18n is not enabled" do
      subject.enabled = false
      expect(subject.locale).to eq('')
    end

    it "should return the locale string when I18n is enabled" do
      subject.enabled = true
      expect(subject.locale).to eq("_#{I18n.locale}")
    end

  end

end
