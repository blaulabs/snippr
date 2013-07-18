# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Processor::Dynamics do

  class Klass
    def method; "METHOD"; end
    def method2(param); "METHOD WITH #{param}"; end
    def method3(param1, param2); "METHOD WITH #{param1} AND #{param2}"; end
  end

  it "replaces placeholders with dynamic values" do
    today = Date.today
    subject.process('Your topup of {topup_amount} at {date_today} was successful.', {
      :topup_amount => "15,00 &euro;",
      :date_today   => today
    }).should == "Your topup of 15,00 &euro; at #{today} was successful."
  end

  it "parses multi-line parameters" do
    tpl = "An instance {var.method2(\"PARAM\t\nETER\")}"
    subject.process(tpl, :var => Klass.new).should == "An instance METHOD WITH PARAMETER"
  end

  it "Does not kill all whitespace" do
    tpl = "An instance {var.method2(\"PART1\t\n SPACE PART2\")}"
    subject.process(tpl, :var => Klass.new).should == "An instance METHOD WITH PART1 SPACE PART2"
  end

  it "allows calling methods on placeholders" do
    tpl = "An instance {var.method()}"
    subject.process(tpl, :var => Klass.new).should == "An instance METHOD"
  end

  it "allows calling methods with parameters on placeholders" do
    tpl = 'An instance {var.method2("PARAMETER")}'
    subject.process(tpl, :var => Klass.new).should == "An instance METHOD WITH PARAMETER"
  end

  it "allows calling methods with multiple parameters on placeholders" do
    tpl = 'An instance {var.method3("PARAMETER1","PARAMETER2")}'
    subject.process(tpl, :var => Klass.new).should == "An instance METHOD WITH PARAMETER1 AND PARAMETER2"
  end

  it "keeps the {snip} if calling a method but the method is not defined" do
    tpl = "An instance {var.method_not_exist()}"
    subject.process(tpl, :var => Klass.new).should == tpl
  end

  it "calls a bang(!) method even if the receiver does not respond_to the method" do
    tpl = "An instance {!var.method_not_exist()}"
    lambda { subject.process(tpl, :var => Klass.new) }.should raise_error(NoMethodError)
  end

end
