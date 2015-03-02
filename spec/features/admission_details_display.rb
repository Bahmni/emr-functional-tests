require 'spec_helper'

feature "Multiple dashboard & display of patient profile" do
  scenario "Verify display of patient profile on ADT, dashboard & Visit page" do

    patient = "Test AdtDashboard"
    patient_details = {:patientNameAndIdentifier => "test adtdashboard (gan200016)",
                       :genderAsText => "Female", :ageAsText => "", :address => "155, gram panchayat, RAJENDRA GRAM",
                       :caste => "hindu", :class => "OBC", :education_details => "Uneducated", :occupation => "Unemployed", :debt => "120000", :distanceFromCenter  => "15.8",
                       :is_urban => "Yes", :cluster => "Semariya", :ration_card => "None", :family_income => ">=36017"}
    admission_details = {:admit_details => "Admission Date	25 Feb 15", :discharge_details => "Discharge Date	25 Feb 15"}

    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_admission_details(admission_details)

      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_admission_details(admission_details)

      go_to_app("adt") do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_admission_details(admission_details)
      end
    end
  end
end
