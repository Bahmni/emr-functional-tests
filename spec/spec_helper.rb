require 'rubygems'
require 'bundler'
Bundler.require(:default)
require "capybara-screenshot"
require "capybara-screenshot/rspec"

auto_load_folders = ['framework', 'support', 'apps']
ActiveSupport::Dependencies.autoload_paths += auto_load_folders.map { |folder_name| File.expand_path("../" + folder_name, __FILE__) }

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.app_host = Settings.root_url
Capybara.run_server = false
Capybara.default_wait_time = 10
Capybara.ignore_hidden_elements = false
Capybara.save_and_open_page_path = File.expand_path("../../screenshots", __FILE__)

headless = Headless.new if Settings.headless

Debugger.start

RSpec.configure do |config|
	config.filter_run_excluding :needs_bug_fix => true
    config.include AppsAwareness
    config.before(:all) do
        Selenium::WebDriver::Firefox::Binary.path=Settings.firefox_path
        headless.start if Settings.headless
    end
    config.after(:all) do
        headless.destroy if Settings.headless
    end
end
