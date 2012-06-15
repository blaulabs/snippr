# -*- encoding : utf-8 -*-
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

    before do
      subject.normalizers << Snippr::Normalizer::DeRester.new # add a second normalizer to ensure chain behaviour
    end

    after do
      subject.normalizers.pop # remove second normalizer
    end

    it "should call normalize on all normalizers, passing the path element between them and returning the last result" do
      seq = sequence "normalizers"
      subject.normalizers.each_with_index do |normalizer, i|
        normalizer.should respond_to(:normalize)
        normalizer.expects(:normalize).with(i.to_s).returns((i + 1).to_s).in_sequence(seq)
      end
      subject.normalize('0').should == subject.normalizers.size.to_s
    end

  end

  describe ".add" do

    before do
      subject.normalizers.clear
      subject.normalizers << Snippr::Normalizer::Camelizer.new
    end

    it "adds the normalizer if an class" do
      subject.add(Snippr::Normalizer::DeRester.new)
      subject.normalizers.should have(2).normalizers
    end

    it "adds the normalizers if an array" do
      subject.add([Snippr::Normalizer::DeRester.new, Snippr::Normalizer::DeRester.new])
      subject.normalizers.should have(3).normalizers
    end

  end

end
