class Home::LoginPage < Page
    set_url '/bahmni/home/#login'

    def login(username, password, location)
        fill_in 'Username', :with => username
        fill_in 'Password', :with => password
        select location, :from => 'Location'
        click_on 'Login'
        wait_for_overlay_to_be_hidden
    end
end