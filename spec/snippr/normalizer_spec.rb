# -*- encoding : utf-8 -*-
require "spec_helper"

describe Snippr::Normalizer do

  describe ".normalizers" do

    it "is an array" do
      expect(subject.normalizers).to be_an(Array)
    end

    it "has a set of default normalizers" do
      normalizers = subject.normalizers
      expect(normalizers.size).to eq(1)
      expect(normalizers[0]).to be_a(Snippr::Normalizer::Camelizer)
    end

  end

  describe ".normalize" do

    before do
      subject.normalizers << Snippr::Normalizer::DeRester.new # add a second normalizer to ensure chain behaviour
    end

    after do
      subject.normalizers.pop # remove second normalizer
    end

    it "calls normalize on all normalizers, passing the path element between them and returning the last result" do
      subject.normalizers.each_with_index do |normalizer, i|
        expect(normalizer).to respond_to(:normalize)
        expect(normalizer).to receive(:normalize).with(i.to_s).and_return((i + 1).to_s)
      end
      expect(subject.normalize('0')).to eq(subject.normalizers.size.to_s)
    end

  end

  describe ".add" do

    before do
      subject.normalizers.clear
      subject.normalizers << Snippr::Normalizer::Camelizer.new
    end

    it "adds the normalizer if an class" do
      subject.add(Snippr::Normalizer::DeRester.new)
      expect(subject.normalizers.size).to eq(2)
    end

    it "adds the normalizers if an array" do
      subject.add([Snippr::Normalizer::DeRester.new, Snippr::Normalizer::DeRester.new])
      expect(subject.normalizers.size).to eq(3)
    end

  end

end
