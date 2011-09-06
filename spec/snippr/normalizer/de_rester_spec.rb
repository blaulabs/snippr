require "spec_helper"

describe Snippr::Normalizer::DeRester do

  {
    "show" => "show",
    "destroy" => "show",
    "new" => "new",
    "create" => "new",
    "edit" => "edit",
    "update" => "edit",
    :show => "show",
    :destroy => "show",
    :new => "new",
    :create => "new",
    :edit => "edit",
    :update => "edit"
  }.each do |replace, with|
    it "should replace #{replace.inspect} in a path with #{with.inspect}" do
      subject.normalize(replace).should == with
    end
  end

end
