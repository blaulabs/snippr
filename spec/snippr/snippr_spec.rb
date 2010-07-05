require "spec_helper"

describe Snippr do
  before :all do
    snippr_path = File.join File.dirname(__FILE__), "..", "fixtures"
    
    if RUBY_PLATFORM =~ /java/
      Snippr::Path::JavaLang::System.set_property Snippr::Path::JVMProperty, snippr_path
    else
      Snippr.path = snippr_path
    end
    Snippr.i18n = false
  end

  it "should return the content of a snippr" do
    Snippr.load(:home).should include("<p>Home</p>")
  end

  it "should return the content a snippr from a subfolder" do
    Snippr.load("tariff/einheit").should include("<p>tariff: einheit</p>")
  end

  it "should return the content a snippr from a subfolder specified via multiple arguments" do
    Snippr.load(:tariff, :einheit).should include("<p>tariff: einheit</p>")
  end

  it "should convert snake_case Symbols to lowerCamelCase Strings" do
    Snippr.load(:topup, :some_error).should include("<p>Some error occurred.</p>")
  end

  it "should wrap the snippr in descriptive comments" do
    Snippr.load(:home).should ==
      "<!-- starting snippr: home -->\n" <<
      "<p>Home</p>\n" <<
      "<!-- closing snippr: home -->"
  end

  it "should replace placeholders with dynamic values" do
    snippr = Snippr.load :topup, :success, :topup_amount => "15,00 &euro;", :date_today => Date.today
    snippr.should include("<p>You're topup of 15,00 &euro; at #{Date.today} was successful.</p>")
  end

  it "should return a fallback wrapped in descriptive comments for missing snipprs" do
    Snippr.load(:doesnotexist).should ==
      "<!-- starting snippr: doesnotexist -->\n" <<
      "<samp class=\"missing snippr\" />\n" <<
      "<!-- closing snippr: doesnotexist -->"
  end
  
  it "should convert wiki links to html links" do
    Snippr.load(:wiki).should == 
      "<!-- starting snippr: wiki -->\n" <<
      "<p>Click <a href=\"http://www.blaulabs.de\">here with blanks</a>.</p>\n" <<
      "<!-- closing snippr: wiki -->"
  end

  describe "I18n" do
    before { Snippr.i18n = true }

    it "should prepend the current locale prefixed with a '_' to a snippr file" do
      I18n.locale = :de
      
      Snippr.load(:i18n, :shop).should ==
        "<!-- starting snippr: i18n/shop_de -->\n" <<
        "<p>Willkommen in unserem Shop.</p>\n" <<
        "<!-- closing snippr: i18n/shop_de -->"
    end

    it "should also work for other locales" do
      I18n.locale = :en
      
      Snippr.load(:i18n, :shop).should ==
        "<!-- starting snippr: i18n/shop_en -->\n" <<
        "<p>Welcome to our shop.</p>\n" <<
        "<!-- closing snippr: i18n/shop_en -->"
    end
  end

end
