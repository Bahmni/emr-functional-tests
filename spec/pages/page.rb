class Page 
	include Capybara::DSL
	include RSpec::Matchers
	include CapybaraDslExtensions

	def self.set_url(url)
		@@url = url
	end

	def open
		visit @@url
		self
	end

	def wait_for_overlay_to_be_hidden
    	wait_until { !page.find('#overlay').visible? }
	end
end