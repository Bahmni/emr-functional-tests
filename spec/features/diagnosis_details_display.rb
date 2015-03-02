require 'spec_helper'

feature "Multiple dashboard & display of diagnosis details" do
  scenario "Verify display of diagnosis on ADT, dashboard & Visit page" do

    patient = "Test AdtDashboard"
    # diagnosis_details = {:order => "PRIMARY", :certainty => "CONFIRMED", :diagnosisDateTime => "25 Feb 15",
    #                      :freeTextAnswer => "nausea", :comments => "After admitting.."}

    diagnosis_details = Array.new
    diagnosis_details[0] = {:order => "PRIMARY", :certainty => "CONFIRMED", :diagnosisDateTime => "25 Feb 15",
                            :freeTextAnswer => "nausea", :comments => "After admitting.."}


    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_diagnosis_details(diagnosis_details)

      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_diagnosis_details(diagnosis_details)

      go_to_app("adt") do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_diagnosis_details(diagnosis_details)
      end
    end
  end
end
