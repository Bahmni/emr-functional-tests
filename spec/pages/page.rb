class Page 
	extend Capybara::DSL
	include Capybara::DSL
	include RSpec::Matchers

	def self.set_url(url)
		@@url = url
	end

	def self.open
		visit @@url
		self.new
	end

	def wait_until
		Timeout.timeout(Capybara.default_wait_time) { value = yield until value }
	end

	def wait_for_overlay_to_be_hidden
    	wait_until { !page.find('#overlay').visible? }
	end
end