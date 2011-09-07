require "spec_helper"

describe Snippr::Processor::Functions do

  describe "#cmd_snip" do

    it "should include snips inside of snips" do
      subject.process('Include a {snip:home} inside a snip').should == "Include a <!-- starting snippr: home -->\n<p>Home</p>\n<!-- closing snippr: home --> inside a snip"
    end


    it "should pass parameters to the include" do
      subject.process('Include a {snip:topup/success} inside a snip', {
        :topup_amount => '10',
        :date_today => '123'
      }).should == "Include a <!-- starting snippr: topup/success -->\n<p>You're topup of 10 at 123 was successful.</p>\n<!-- closing snippr: topup/success --> inside a snip"
    end

    it "should allow additional parameters to be passed to the included snippet" do
      subject.process('Include a {snip:topup/success,topup_amount=99} inside a snip', {
        :date_today => '123'
      }).should == "Include a <!-- starting snippr: topup/success -->\n<p>You're topup of 99 at 123 was successful.</p>\n<!-- closing snippr: topup/success --> inside a snip"
    end

    it "should allow additional parameters of the snip call to override parent options" do
      subject.process('Include a {snip:topup/success,topup_amount=99} inside a snip', {
        :date_today => '123',
        :topup_amount => '1'
      }).should == "Include a <!-- starting snippr: topup/success -->\n<p>You're topup of 99 at 123 was successful.</p>\n<!-- closing snippr: topup/success --> inside a snip"
    end

    context "for home/show/blauappOverviewBoxMobile (regression test)" do

      before do
        Snippr::Normalizer.normalizers << Snippr::Normalizer::DeRester.new # add a second normalizer to ensure chain behaviour
        Snippr::I18n.enabled = true
        I18n.locale = :de
      end

      after do
        Snippr::Normalizer.normalizers.pop # remove second normalizer
      end

      it "should work" do
        subject.process("{snip:home/show/blauappOverviewBoxMobile}").should == "<!-- missing snippr: home/show/blauappOverviewBoxMobile_de -->"
      end

    end

  end

  describe "#hashify" do

    it "should process a single argument with no value as default" do
      subject.send(:hashify, "test").should == { :default => "test" }
    end

    it "should process a single argument with key and value" do
      subject.send(:hashify, "key=value").should == { :key => "value" }
    end

    it "should process multiple arguments delimited by comma" do
      subject.send(:hashify, "key=value,key2=value2").should == { :key => "value", :key2 => "value2" }
    end

    it "should process a combination of all arguments" do
      subject.send(:hashify, "default,key=value,key2=value2").should == { :default => 'default', :key => "value", :key2 => "value2" }
    end

  end

end
