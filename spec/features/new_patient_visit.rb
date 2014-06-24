require 'spec_helper'

feature "new patient visit" do
    background do
        login('superman', 'Admin123')
    end

    given(:new_patient) do
        {:given_name => "Ram#{Time.now.to_i}", :family_name => 'Singh',
         :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari'}
    end

    scenario "clinicians consulting the patient" do
    	go_to_app(:registration) do
			register_new_patient(:patient => new_patient, :visit_type => 'OPD')
            visit_page.should_be_current_page
    	end

    	go_to_app(:clinical) do
			patient_search_page.should_have_patient(new_patient[:given_name])
			patient_search_page.show_active_patient(new_patient[:given_name])
    	end
    end
end