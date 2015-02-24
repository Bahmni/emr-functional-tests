require 'spec_helper'

feature "Adt dashboard" do
  scenario "verify patient profile information" do

    patient = "Test AdtFlow"
    patient_details = {:patientNameAndIdentifier => "test adtflow (gan200014)",
                       :genderAsText => "Male", :ageAsText => "22 days", :address => "123, GP, RADGA"}

    log_in_to_app(:adt, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_patient_profile_information(patient_details)
    end
  end
end
