class Home::App < App
	def login(*args)
		login_page.login *args
	end
end