# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Processor do

  describe ".processors" do

    it "is an array" do
      expect(subject.processors).to be_an(Array)
    end

    it "has a set of default processors" do
      processors = subject.processors
      expect(processors.size).to eq(5)
      expect(processors[0]).to be_a(Snippr::Processor::Block)
      expect(processors[1]).to be_a(Snippr::Processor::Functions)
      expect(processors[2]).to be_a(Snippr::Processor::Dynamics)
      expect(processors[3]).to be_a(Snippr::Processor::Links)
      expect(processors[4]).to be_a(Snippr::Processor::Wikilinks)
    end

  end

  describe ".process" do

    it "calls process on all processors, passing the content between them and returning the last result" do
      parent = Snippr::Snip.new
      subject.processors.each_with_index do |processor, i|
        expect(processor).to respond_to(:process)
        expect(processor).to receive(:process).with(i.to_s, {'1' => '2', :_parent => parent}).and_return((i + 1).to_s)
      end
      expect(subject.process('0', {'1' => '2'}, parent)).to eq(subject.processors.size.to_s)
    end

  end

end
