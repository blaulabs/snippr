# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Processor::Dynamics do

  class Klass
    def method; "METHOD"; end
    def method2(param); "METHOD WITH #{param}"; end
    def method3(param1, param2); "METHOD WITH #{param1} AND #{param2}"; end
    def method4; ""; end
  end

  it "replaces placeholders with dynamic values" do
    today = Date.today
    expect(subject.process('Your topup of {topup_amount} at {date_today} was successful.', {
      :topup_amount => "15,00 &euro;",
      :date_today   => today
    })).to eq("Your topup of 15,00 &euro; at #{today} was successful.")
  end

  it 'parses the placeholden when surrounded by quotes' do
    tpl = 'start class="{var}" end'
    expect(subject.process(tpl, :var => "cssclass")).to eq('start class="cssclass" end');
  end

  it "parses multi-line parameters" do
    tpl = "An instance {var.method2(\"PARAM\t\nETER\")}"
    expect(subject.process(tpl, :var => Klass.new)).to eq("An instance METHOD WITH PARAMETER")
  end

  it "Does not kill all whitespace" do
    tpl = "An instance {var.method2(\"PART1\t\n SPACE PART2\")}"
    expect(subject.process(tpl, :var => Klass.new)).to eq("An instance METHOD WITH PART1 SPACE PART2")
  end

  it "allows calling methods on placeholders" do
    tpl = "An instance {var.method()}"
    expect(subject.process(tpl, :var => Klass.new)).to eq("An instance METHOD")
  end

  it "allows calling methods with parameters on placeholders" do
    tpl = 'An instance {var.method2("PARAMETER")}'
    expect(subject.process(tpl, :var => Klass.new)).to eq("An instance METHOD WITH PARAMETER")
  end

  it "allows calling methods with multiple parameters on placeholders" do
    tpl = 'An instance {var.method3("PARAMETER1","PARAMETER2")}'
    expect(subject.process(tpl, :var => Klass.new)).to eq("An instance METHOD WITH PARAMETER1 AND PARAMETER2")
  end

  it "keeps the {snip} if calling a method but the method is not defined" do
    expect(subject.process("An instance {var.method_not_exist()}", :var => Klass.new)).to eq("An instance {var.method_not_exist()}")
  end

  it "calls a bang(!) method even if the receiver does not respond_to the method" do
    tpl = "An instance {!var.method_not_exist()}"
    expect { subject.process(tpl, :var => Klass.new) }.to raise_error(NoMethodError)
  end

  it "leaves the dynamic vslue untouched if no replacement and default exists" do
    tpl = <<-HEREDOC
      .clazz {
      }

      .clazz {}
      </style>
    HEREDOC
    expect(subject.process(tpl)).to eq "      .clazz {\n      }\n\n      .clazz {}\n      </style>\n"
  end

  context "default handling" do
    it "defaults the value if the content is empty" do
      expect(subject.process("{empty|default}", empty: "")).to eq "default"
    end

    it "defaults the value if the method calls return value is empty" do
      expect(subject.process("{var.method4()|default2}", var: Klass.new )).to eq "default2"
    end
  end

  context "nested placeholders" do
    it "allows nested placeholders when calling a method" do
      tpl = 'An instance {var.method3("{var2}","PARAMETER2")}'
      expect(subject.process(tpl, :var => Klass.new, :var2 => "VAR")).to eq("An instance METHOD WITH VAR AND PARAMETER2")
    end

    it "allows nested placeholders with method calls when calling a method" do
      tpl = 'An instance {var.method3("{var2.method()}","PARAMETER2")}'
      expect(subject.process(tpl, :var => Klass.new, :var2 => Klass.new)).to eq("An instance METHOD WITH METHOD AND PARAMETER2")
    end

    it "allows nested placeholders with method calls on the same object when calling a method" do
      tpl = 'An instance {var.method2("{var.method2("{var.method3("A","B")}")}")}'
      expect(subject.process(tpl, :var => Klass.new)).to eq("An instance METHOD WITH METHOD WITH METHOD WITH A AND B")
    end
  end

end
