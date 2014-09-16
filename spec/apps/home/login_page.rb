class Home::LoginPage < Page
    set_url '/bahmni/home/#login'

    def login(credentials)
        fill_in 'Username', :with => credentials[:username] || Settings.default_username
        fill_in 'Password', :with => credentials[:password] || Settings.default_password
        select credentials[:location], :from => 'Location'
        click_on 'Login'
        wait_for_overlay_to_be_hidden
    end
end