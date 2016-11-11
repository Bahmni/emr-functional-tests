class Erp::LoginPage < Page

    def login
        fill_in 'login', :with => Settings.erp_default_username
        fill_in 'password', :with =>  Settings.erp_default_password
        select 'openerp', :from => 'db'
        click_on 'Log in'
        wait_for_erploading_to_complete
    end
end
