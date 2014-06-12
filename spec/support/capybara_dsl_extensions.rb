module CapybaraDslExtensions
	def click_icon_link(text)
		find('a', :text => text).click
	end

	def wait_until
		Timeout.timeout(Capybara.default_wait_time) { value = yield until value }
	end
end