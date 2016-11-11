class Eli::LoginPage < Page

    def login
        fill_in 'loginName', :with => Settings.elis_default_username
        fill_in 'password', :with =>  Settings.elis_default_password
        click_on 'Submit'
        wait_for_overlay_to_be_hidden
    end
end
