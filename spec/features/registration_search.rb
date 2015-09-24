require 'spec_helper'

feature "Registration search " do
  scenario "registration search by name results, search by id patient details and patient Visit" do
    updated_patient_details = {:village => 'Nandhigama'}
    new_patient = {:given_name => "Ram#{(0...5).map { (97 + rand(26)).chr }.join}", :family_name => 'Singh', :gender => 'Male', :age => {:years => "40"}, :village => 'Ganiyari'}
    patient_id=""
    visit_info = {:fee => 15, :weight => 70, :height => 170, :comments => 'Billed'}

    log_in_to_app(:Registration, :location => 'OPD-1') do
      register_new_patient(:patient => new_patient)
      patient_id= patient_page.get_patient_id
    end

    log_in_to_app(:Registration, :location => 'OPD-1') do
      verify_search_by_name_results(new_patient)
      verify_details_in_patient_page(patient_id,new_patient)
      verify_back_button_in_visit_page(:visit_type => 'OPD')
      #verify_details_after_update_village(updated_patient_details[:village])
      save_existing_patient_visit(visit_info)
    end

  end
end
