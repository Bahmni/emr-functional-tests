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

	def current_path_with_fragment
	  current_url.sub(%r{.*?://},'')[%r{[/\?\#].*}] || '/'
	end

	def should_be_current_page
		url_template = Addressable::Template.new(@@url + '{?query_params*}')
		wait_until { !url_template.match(current_path_with_fragment).nil? }
	end

	def wait_for_overlay_to_be_hidden
    	wait_until { !page.find('#overlay').visible? }
	end
end