class Home::DashboardPage < Page
	def go_to_app(name)
		find('a', :text => name).click
		wait_for_overlay_to_be_hidden
	end
end