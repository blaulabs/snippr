require "spec_helper"

describe Snippr::Processor::Functions do

  describe "#cmd_snip" do

    it "should include snips inside of snips" do
      Snippr::Processor::Functions.new.process('Include a {snip:home} inside a snip').should == "Include a <!-- starting snippr: home -->\n<p>Home</p>\n<!-- closing snippr: home --> inside a snip"
    end


    it "should pass parameters to the include" do
      Snippr::Processor::Functions.new.process('Include a {snip:topup/success} inside a snip', {
        :topup_amount => '10',
        :date_today => '123'
      }).should == "Include a <!-- starting snippr: topup/success -->\n<p>You're topup of 10 at 123 was successful.</p>\n<!-- closing snippr: topup/success --> inside a snip"
    end

    it "should allow additional parameters to be passed to the included snippet" do
      Snippr::Processor::Functions.new.process('Include a {snip:topup/success,topup_amount=99} inside a snip', {
        :date_today => '123'
      }).should == "Include a <!-- starting snippr: topup/success -->\n<p>You're topup of 99 at 123 was successful.</p>\n<!-- closing snippr: topup/success --> inside a snip"
    end

    it "should allow additional parameters of the snip call to override parent options" do
      Snippr::Processor::Functions.new.process('Include a {snip:topup/success,topup_amount=99} inside a snip', {
        :date_today => '123',
        :topup_amount => '1'
      }).should == "Include a <!-- starting snippr: topup/success -->\n<p>You're topup of 99 at 123 was successful.</p>\n<!-- closing snippr: topup/success --> inside a snip"
    end

  end

  describe "#hashify" do

    before :all do
      @processor = Snippr::Processor::Functions.new
    end

    it "should process a single argument with no value as default" do
      @processor.send(:hashify, "test").should == { :default => "test" }
    end

    it "should process a single argument with key and value" do
      @processor.send(:hashify, "key=value").should == { :key => "value" }
    end

    it "should process multiple arguments delimited by comma" do
      @processor.send(:hashify, "key=value,key2=value2").should == { :key => "value", :key2 => "value2" }
    end

    it "should process a combination of all arguments" do
      @processor.send(:hashify, "default,key=value,key2=value2").should == { :default => 'default', :key => "value", :key2 => "value2" }
    end

  end

end
