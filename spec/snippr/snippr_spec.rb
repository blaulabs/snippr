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
    Snippr.load(:home).should load_snippr('home.snip')
  end

  it "should return the content a snippr from a subfolder" do
    Snippr.load("tariff/einheit").should load_snippr('tariff/einheit.snip')
  end

  it "should return the content a snippr from a subfolder specified via multiple arguments" do
    Snippr.load(:tariff, :einheit).should load_snippr('tariff/einheit.snip')
  end

  it "should convert snake_case Symbols to lowerCamelCase Strings" do
    Snippr.load(:topup, :some_error).should load_snippr('topup/someError.snip')
  end

  it "should wrap the snippr in descriptive comments" do
    Snippr.load(:home).should load_snippr('home.snip')
  end

  it "should replace placeholders with dynamic values" do
    today = Date.today
    Snippr.load(:topup, :success, {
      :topup_amount => "15,00 &euro;",
      :date_today   => today
    }).should load_snippr_with_content('topup/success.snip', "<p>You're topup of 15,00 &euro; at #{today} was successful.</p>")
  end

  it "should return a fallback wrapped in descriptive comments for missing snipprs" do
    Snippr.load(:doesnotexist).should load_snippr_with_content('doesnotexist', '<samp class="missing snippr" />')
  end
  
  it "should convert wiki links to html links" do
    Snippr.load(:wiki).should load_snippr_with_content('wiki.snip', '<p>Click <a href="http://www.blaulabs.de">here with blanks</a>.</p>')
  end

  describe "I18n" do
    before { Snippr.i18n = true }

    it "should prepend the current locale prefixed with a '_' to a snippr file" do
      I18n.locale = :de
      Snippr.load(:i18n, :shop).should load_snippr('i18n/shop_de.snip')
    end

    it "should also work for other locales" do
      I18n.locale = :en
      Snippr.load(:i18n, :shop).should load_snippr('i18n/shop_en.snip')
    end
  end

  it "should add a method missing_snippr? that returns false for snipprs that were found" do
    Snippr.load(:home).missing_snippr?.should == false
  end

  it "should add a method missing_snippr? that returns true for snipprs that weren't found" do
    Snippr.load(:doesnotexist).missing_snippr?.should == true
  end

end
