require "spec_helper"

describe Snippr::Processor do

  describe ".processors" do

    it "should be an array" do
      subject.processors.should be_an(Array)
    end

    it "should have a set of default processors" do
      processors = subject.processors
      processors.size.should == 4
      processors[0].should be_a(Snippr::Processor::Functions)
      processors[1].should be_a(Snippr::Processor::Dynamics)
      processors[2].should be_a(Snippr::Processor::Links)
      processors[3].should be_a(Snippr::Processor::Wikilinks)
    end

  end

  describe ".process" do

    it "should call process on all processors, passing the content between them and returning the last result" do
      seq = sequence 'processors'
      subject.processors.each_with_index do |processor, i|
        processor.should respond_to(:process)
        processor.expects(:process).with(i.to_s, {'1' => '2'}).returns((i + 1).to_s).in_sequence(seq)
      end
      subject.process('0', {'1' => '2'}).should == subject.processors.size.to_s
    end

  end

end
