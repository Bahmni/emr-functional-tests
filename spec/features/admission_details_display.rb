require 'spec_helper'

feature "Admission display control" do
  scenario "Verify display of admission details on ADT, dashboard & Visit page" do

    patient = "Test AdtDashboard"
    admission_details = {:admit_details => "Admission Date  25 Feb 15", :discharge_details => "Discharge Date	25 Feb 15"}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_admission_details(admission_details)

      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_admission_details(admission_details)

      go_to_app(:InPatient) do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_admission_details(admission_details)
      end
    end
  end
end
