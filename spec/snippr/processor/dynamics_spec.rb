require "spec_helper"

describe Snippr::Processor::Dynamics do

  it "should replace placeholders with dynamic values" do
    today = Date.today
    Snippr::Processor::Dynamics.new.process('Your topup of {topup_amount} at {date_today} was successful.', {
      :topup_amount => "15,00 &euro;",
      :date_today   => today
    }).should == "Your topup of 15,00 &euro; at #{today} was successful."
  end

end
