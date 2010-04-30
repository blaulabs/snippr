require "spec_helper"

describe Snippr do
  before :all do
    snippr_path = File.join File.dirname(__FILE__), "..", "fixtures"
    
    if RUBY_PLATFORM =~ /java/
      SnipprPath::JavaLang::System.set_property SnipprPath::JVMProperty, snippr_path
    else
      Snippr.path = snippr_path
    end
  end

  it "should return the content of a snippr" do
    Snippr.new(:home).to_s.should include("<p>Home</p>")
  end

  it "should return the content a snippr from a subfolder" do
    Snippr.new("tariff/einheit").to_s.should include("<p>tariff: einheit</p>")
  end

  it "should return the content a snippr from a subfolder specified via multiple arguments" do
    Snippr.new(:tariff, :einheit).to_s.should include("<p>tariff: einheit</p>")
  end

  it "should convert snake_case Symbols to lowerCamelCase Strings" do
    Snippr.new(:topup, :some_error).to_s.should include("<p>Some error occurred.</p>")
  end

  it "should wrap the snippr in descriptive comments" do
    Snippr.new(:home).to_s.should ==
      "<!-- starting with snippr: home -->\n" <<
      "<p>Home</p>\n" <<
      "<!-- ending with snippr: home -->"
  end

  it "should replace placeholders with dynamic values" do
    snippr = Snippr.new :topup, :success, :topup_amount => "15,00 &euro;", :date_today => Date.today
    snippr.to_s.should include("<p>You're topup of 15,00 &euro; at #{Date.today} was successful.</p>")
  end

  it "should return a fallback wrapped in descriptive comments for missing snipprs" do
    Snippr.new(:doesnotexist).to_s.should ==
      "<!-- starting with snippr: doesnotexist -->\n" <<
      "<samp class=\"missing snippr\" />\n" <<
      "<!-- ending with snippr: doesnotexist -->"
  end

  it "should raise an ArgumentError if the +path+ does not exist" do
    lambda { Snippr.path = "does_not_exist" }.should raise_exception(ArgumentError)
  end

end