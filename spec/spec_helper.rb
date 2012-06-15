# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler'
require 'snippr'

Bundler.require(:default, :development)

RSpec.configure do |config|
  config.mock_with :mocha
  config.before do
    Snippr::I18n.enabled = nil
    Snippr::Links.adjust_urls_except = nil
    snippr_path = File.expand_path '../fixtures', __FILE__
    if RUBY_PLATFORM =~ /java/
      Snippr::Path.path = snippr_path
      Snippr::Path::JavaLang::System.set_property Snippr::Path::JVM_PROPERTY, snippr_path
    else
      Snippr::Path.path = snippr_path
    end
  end
end
