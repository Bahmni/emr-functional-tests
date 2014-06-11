require 'spec_helper'

describe "new patient visit", :type => :feature do
    it "should allow clinicians to consult the patient", :js => true do
    	login_page = LoginPage.open
        dashboard_page = login_page.login(:username => 'superman', :password => 'Admin123')
        dashboard_page.go_to_app('Registration')
    end
end