# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Tardis do
  describe ".enabled=" do
    it "accepts a block" do
      Snippr::Tardis.enabled = -> { "truthy" }
      Snippr::Tardis.enabled.should eq "truthy"
    end

    it "accepts simple values" do
      Snippr::Tardis.enabled = "truthy"
      Snippr::Tardis.enabled.should be_true
    end
  end
end
