# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler'
require 'snippr'

Bundler.require(:default, :development)

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.before do
    Snippr::I18n.enabled = nil
    Snippr::Links.adjust_urls_except = nil
    snippr_path = File.expand_path '../fixtures', __FILE__
    Snippr::Path.path = snippr_path
  end
end
