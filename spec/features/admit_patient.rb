require 'spec_helper'

feature "admit patient" do
  scenario "verify patient admit with no open visit" do

    patient1 = "Test NoOpenVisit Scenario"
    admit_details = {:action => "Admit Patient", :notes => "Admit the patient"}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient1)
      patient_dashboard_page.verify_absence_of_start_consultation_link
      patient_dashboard_page.verify_absence_of_current_visit
      end
      go_to_app(:InPatient) do
        patient_search_page.view_patient_from_all_tab(patient1)
        patient_dashboard_page.perform_admit_action(admit_details)
       end
      go_to_app(:Clinical) do
        patient_search_page.view_patient_from_active_tab(patient1)
        patient_dashboard_page.verify_presence_of_start_consultation_link
        patient_dashboard_page.verify_presence_of_current_visit
        patient_dashboard_page.verify_visit_type("IPD")
      end
  end
end
