require 'spec_helper'

describe "new patient visit", :type => :feature do
    it "should allow clinicians to consult the patient", :js => true do
    	LoginPage.open.login(:username => 'superman', :password => 'Admin123')

    	on_app(:home) { dashboard_page.go_to_app('Registration') }

    	on_app(:registration) do
    		patient_search_page.go_to_create_new
			patient_page.fill({:given_name => 'Ram', :family_name => 'Singh', :gender => 'Male',
							   :age => {:years => 40}, :village => 'Ganiyari'})
			patient_page.start_visit('OPD')
    	end
    end
end