require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

Rspec.configure do |config|
  config.mock_with :mocha
  config.before do
    Snippr::I18n.enabled = nil
    snippr_path = File.expand_path '../fixtures', __FILE__
    if RUBY_PLATFORM =~ /java/
      Snippr::Path.path = snippr_path
      Snippr::Path::JavaLang::System.set_property Snippr::Path::JVM_PROPERTY, snippr_path
    else
      Snippr::Path.path = snippr_path
    end
  end
end

require 'snippr'
