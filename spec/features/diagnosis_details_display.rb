require 'spec_helper'

feature "Diagnosis" do
  scenario "Verify display of diagnosis on ADT, dashboard & Visit page" do

    patient = "Test AdtDashboard"
    diagnosis_details = Array.new
    diagnosis_details[0] = {:order => "PRIMARY", :certainty => "CONFIRMED", :diagnosisDateTime => "25 Feb 15",
                            :freeTextAnswer => "nausea", :comments => "After admitting.."}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_diagnosis_details(diagnosis_details)

      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_diagnosis_details(diagnosis_details)

      go_to_app(:InPatient) do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_diagnosis_details(diagnosis_details)
      end
    end
  end

  scenario 'Add coded & non-coded diagnosis for existing patient' do
    patient = 'Test AdtDashboard'
    coded_diagnosis = {:index => 0, :name => 'Dog bite', :order => 'PRIMARY', :certainty => 'PRESUMED'}
    non_coded_diagnosis = {:index => 0, :name => 'Cat bite', :order => 'PRIMARY', :certainty => 'PRESUMED'}
    diagnoses = [coded_diagnosis, non_coded_diagnosis]

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.start_consultation
      diagnosis_page.add_coded_diagnosis(coded_diagnosis)
      diagnosis_page.save
      diagnosis_page.add_non_coded_diagnosis(non_coded_diagnosis)
      diagnosis_page.save
      diagnosis_page.verify_current_diagnosis(diagnoses)
      observations_page.go_to_dashboard_page

      patient_dashboard_page.verify_diagnosis_details(diagnoses)
    end
  end

  scenario 'Edit coded diagnosis for existing patient' do
    patient = 'Test AdtDashboard'

    log_in_as_different_user(:Clinical) do
      coded_diagnosis = {:index => 0, :name => 'Dog bite', :order => 'PRIMARY', :certainty => 'PRESUMED'}
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.start_consultation
      coded_diagnosis[:status] = 'CURED'
      diagnosis_page.edit_past_diagnosis(coded_diagnosis)
      diagnosis_page.save
      diagnosis_page.verify_current_diagnosis([coded_diagnosis])
      observations_page.go_to_dashboard_page

      patient_dashboard_page.verify_diagnosis_details([coded_diagnosis])
    end

  end

end
