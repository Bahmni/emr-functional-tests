require 'spec_helper'

feature "existing patient admit and discharge verification" do
  scenario "verify admit and discharge" do

    patient1 = "Test AdtFlow"
    disposition_details = {:disposition => "Admit Patient", :notes => "Admit the patient"}


    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_active_tab(patient1)
      patient_dashboard_page.start_consultation
      disposition_page.go_to_tab("Disposition")
      disposition_page.provide_disposition(disposition_details)
      disposition_page.save

      disposition_page.go_to_dashboard_page
      patient_dashboard_page.verify_disposition_details(disposition_details)
      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_disposition_details(disposition_details)
      visit_page.navigate_to_home
      go_to_app("adt") do
       patient_search_page.view_patient_from_To_Admit_tab(patient1)
      end
  end
  end
  end