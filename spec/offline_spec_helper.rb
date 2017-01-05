require 'rubygems'
require 'bundler'
Bundler.require(:default)
require "capybara-screenshot"
require "capybara-screenshot/rspec"

auto_load_folders = ['framework', 'support', 'apps']
ActiveSupport::Dependencies.autoload_paths += auto_load_folders.map { |folder_name| File.expand_path("../" + folder_name, __FILE__) }

Capybara.default_driver = :chrome
Capybara.javascript_driver = :chrome
Capybara.current_driver = :chrome

Capybara.register_driver :chrome do |app|

  driver = Capybara::Selenium::Driver.new(app, :browser => :chrome,
                                          :switches => [ '--load-extension=' + "/tmp/bahmni-offline/chrome",
                                                         '--test-type'
                                          ])
end


Capybara.app_host = Settings.root_url
Capybara.run_server = false
Capybara.default_wait_time = 50
Capybara.ignore_hidden_elements = false
Capybara.save_and_open_page_path = File.expand_path("../../screenshots", __FILE__)

Headless.new.start if Settings.headless

RSpec.configure do |config|
  config.include AppsAwareness
  config.after(:each) do
    sleep 0.25 #Give time for the browser to set the angular_exception when exception happens during last step
    exceptions = page.execute_script('return window.angular_exception')
    if exceptions
      exceptions_string = exceptions.collect { |e| e['errorMessage']+"\n" + e['stackTrace'].join("\n") }
      fail "javascript error(s) found!\n#{exceptions_string.join("\n")}"
      page.execute_script('delete window.angular_exception')
    end
  end
end
