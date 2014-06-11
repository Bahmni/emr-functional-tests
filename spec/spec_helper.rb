require 'rubygems'
require 'bundler'
Bundler.require(:default)

ActiveSupport::Dependencies.autoload_paths += [File.expand_path("../support", __FILE__), File.expand_path("../pages", __FILE__)]

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.app_host = Settings.root_url
Capybara.run_server = false
Capybara.default_wait_time = 10
Capybara.ignore_hidden_elements = false

RSpec.configure do |config|
  config.before(:all) do
    Selenium::WebDriver::Firefox::Binary.path=Settings.firefox_path
    Headless.new.start
  end
end
