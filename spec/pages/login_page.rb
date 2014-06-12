class LoginPage < Page
	set_url '/home/#login'

	def login(username, password)
	    fill_in 'Username', :with => username
		fill_in 'Password', :with => password
    	click_on 'Login'
		wait_for_overlay_to_be_hidden
	end
end