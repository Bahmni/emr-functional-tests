require 'spec_helper'

feature "new patient visit" do
    scenario "clinicians consulting the patient" do
    	login_page.open.login('superman', 'Admin123')

    	patient_given_name = "Ram#{Time.now.to_i}"
    	go_to_app(:registration) do
			app.register_new_patient(:given_name => patient_given_name, :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari')
			   .start_visit('OPD')
    	end

    	go_to_app(:clinical) do
			patient_search_page.should_have_patient(patient_given_name)
			patient_search_page.show_active_patient(patient_given_name)
    	end
    end
end