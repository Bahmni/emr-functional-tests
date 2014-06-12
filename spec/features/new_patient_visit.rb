require 'spec_helper'

feature "new patient visit" do
    scenario "clinicians consulting the patient" do
    	login_page.open.login('superman', 'Admin123')

    	go_to_app(:registration) do
			app.register_new_patient(:given_name => "Ram#{Time.now.to_i}", :family_name => 'Singh',
                           :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari')
			    .start_visit('OPD')
    	end
    end
end