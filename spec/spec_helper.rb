require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

Rspec.configure do |config|
  config.mock_with :mocha
end

Dir[File.expand_path "../support/**/*.rb", __FILE__].each {|f| require f}
require "snippr"
