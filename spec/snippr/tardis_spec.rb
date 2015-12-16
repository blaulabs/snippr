# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Tardis do
  describe ".enabled=" do
    it "accepts a block" do
      Snippr::Tardis.enabled = -> { "truthy" }
      expect(Snippr::Tardis.enabled).to eq "truthy"
    end

    it "accepts simple values" do
      Snippr::Tardis.enabled = "truthy"
      expect(Snippr::Tardis.enabled).to eq true
    end
  end
end
