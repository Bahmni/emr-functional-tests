require 'spec_helper'

feature "new patient visit" do
    background do
        login('superman', 'Admin123')
    end

    given(:new_patient) do
        {:given_name => "Ram#{Time.now.to_i}", :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari'}
    end

    scenario "registration and consultation" do
        go_to_app(:registration) do
            register_new_patient(:patient => new_patient, :visit_type => 'OPD')
            visit_page.should_be_current_page
            visit_info = {:fee => 15, :weight => 70, :height => 170, :comments => 'Billed'}
            visit_page.save_new_patient_visit(visit_info)
        end

        go_to_app(:clinical) do
            patient_search_page.should_have_active_patient(new_patient)
            patient_search_page.view_patient(new_patient)
            patient_dashboard_page.verify_visit_vitals_info({:weight => 70, :height => 170, :bmi => 24.22, :bmi_status => 'Normal'})
        end
    end
end