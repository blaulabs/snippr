require "spec_helper"

describe Snippr::Normalizer do

  describe ".normalizers" do

    it "should be an array" do
      subject.normalizers.should be_an(Array)
    end

    it "should have a set of default normalizers" do
      normalizers = subject.normalizers
      normalizers.size.should == 1
      normalizers[0].should be_a(Snippr::Normalizer::Camelizer)
    end

  end

  describe ".normalize" do

    it "should call normalize on all normalizers, passing the path element between them and returning the last result" do
      subject.normalizers << Snippr::Normalizer::DeRester.new # add a second normalizer to ensure chain behaviour
      begin
        seq = sequence "normalizers"
        subject.normalizers.each_with_index do |normalizer, i|
          normalizer.should respond_to(:normalize)
          normalizer.expects(:normalize).with(i.to_s).returns((i + 1).to_s).in_sequence(seq)
        end
        subject.normalize('0').should == subject.normalizers.size.to_s
      ensure
        subject.normalizers.pop # remove second normalizer
      end
    end

  end

end
