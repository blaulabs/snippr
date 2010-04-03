require "spec_helper"

describe Snippet do
  before :all do
    snippet_path = File.join File.dirname(__FILE__), "..", "fixtures"
    if RUBY_PLATFORM =~ /java/
      SnippetPath::JavaLang::System.set_property SnippetPath::JVMProperty, snippet_path
    else
      Snippet.snippet_path = snippet_path
    end
  end

  it "should return the content of a snippet" do
    Snippet.new(:home).to_s.should include("<p>Home</p>")
  end

  it "should return the content a snippet from a subfolder" do
    Snippet.new("tariff/einheit").to_s.should include("<p>tariff: einheit</p>")
  end

  it "should return the content a snippet from a subfolder specified via multiple arguments" do
    Snippet.new(:tariff, :einheit).to_s.should include("<p>tariff: einheit</p>")
  end

  it "should wrap the snippet in descriptive comments" do
    Snippet.new(:home).to_s.should ==
      "<!-- starting with snippet: home -->\n" <<
      "<p>Home</p>\n" <<
      "<!-- ending with snippet: home -->"
  end

  it "should replace placeholders with dynamic values" do
    snippet = Snippet.new :topup, :success, :topup_amount => "15,00 &euro;", :date_today => Date.today
    snippet.to_s.should include("<p>You're topup of 15,00 &euro; at #{Date.today} was successful.</p>")
  end

  it "should return a fallback wrapped in descriptive comments for missing snippets" do
    Snippet.new(:does_not_exist).to_s.should ==
      "<!-- starting with snippet: does_not_exist -->\n" <<
      "<samp class=\"missing snippet\" />\n" <<
      "<!-- ending with snippet: does_not_exist -->"
  end

  it "should raise an ArgumentError if the snippet_path does not exist" do
    lambda { Snippet.snippet_path = "does_not_exist" }.should raise_exception(ArgumentError)
  end

end