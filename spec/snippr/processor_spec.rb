# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Processor do

  describe ".processors" do

    it "is an array" do
      subject.processors.should be_an(Array)
    end

    it "has a set of default processors" do
      processors = subject.processors
      processors.size.should == 5
      processors[0].should be_a(Snippr::Processor::Block)
      processors[1].should be_a(Snippr::Processor::Functions)
      processors[2].should be_a(Snippr::Processor::Dynamics)
      processors[3].should be_a(Snippr::Processor::Links)
      processors[4].should be_a(Snippr::Processor::Wikilinks)
    end

  end

  describe ".process" do

    it "calls process on all processors, passing the content between them and returning the last result" do
      subject.processors.each_with_index do |processor, i|
        processor.should respond_to(:process)
        expect(processor).to receive(:process).with(i.to_s, {'1' => '2'}).and_return((i + 1).to_s)
      end
      subject.process('0', {'1' => '2'}).should == subject.processors.size.to_s
    end

  end

end
