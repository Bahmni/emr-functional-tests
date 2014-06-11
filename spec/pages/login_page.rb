class LoginPage < Page
	set_url '/home/#login'

	def login(user)
	    fill_in 'Username', :with => user[:username]
		fill_in 'Password', :with => user[:password]
    	click_on 'Login'
		wait_for_overlay_to_be_hidden
	end
end