require 'spec_helper'

feature "patient admit and discharge verification" do
  scenario "verify patient admit, discharge & undo discharge flow" do

    patient1 = "Test AdtFlow"
    admit_disposition_details = {:disposition => "Admit Patient", :notes => "Admit the patient"}
    discharge_disposition_details = {:disposition => "Discharge Patient", :notes => "Discharge the patient"}
    admit_details = {:action => "Admit Patient", :notes => "Admit the patient"}
    discharge_details = {:action => "Discharge Patient", :notes => "Discharge the patient"}
    undo_discharge_details = {:action => "Undo Discharge", :notes => "Undo Discharge"}

    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_active_tab(patient1)
      patient_dashboard_page.start_consultation
      disposition_page.provide_disposition(admit_disposition_details)

      disposition_page.go_to_dashboard_page
      patient_dashboard_page.verify_disposition_details(admit_disposition_details)
      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_disposition_details(admit_disposition_details)
      visit_page.navigate_to_home
      go_to_app("adt") do
        patient_search_page.view_patient_from_to_admit_tab(patient1)
        patient_dashboard_page.verify_disposition_details(admit_disposition_details)
        patient_dashboard_page.perform_admit_action(admit_details)
        ward_list_page.navigate_back_to_patient_search_page
        patient_search_page.view_patient_from_admitted_tab(patient1)
      end
    end

    log_in_as_different_user(:clinical) do
      patient_search_page.view_patient_from_active_tab(patient1)
      patient_dashboard_page.start_consultation
      disposition_page.provide_disposition(discharge_disposition_details)

      disposition_page.go_to_dashboard_page
      patient_dashboard_page.verify_disposition_details(discharge_disposition_details)
      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_disposition_details(discharge_disposition_details)
      visit_page.navigate_to_home
      go_to_app("adt") do
        patient_search_page.view_patient_from_to_discharge_tab(patient1)
        patient_dashboard_page.verify_disposition_details(discharge_disposition_details)
        patient_dashboard_page.perform_discharge_action(discharge_details)
        patient_search_page.view_patient_from_all_tab(patient1)
        # patient_dashboard_page.perform_undo_discharge_action(undo_discharge_details)
        # patient_search_page.view_patient_from_admitted_tab(patient1)
      end
    end
  end


  scenario "verify undo disposition" do
    patient = "Test AddDrugScenario"
    admit_disposition_details = {:disposition => "Admit Patient", :notes => "Admit the patient"}
    undo_disposition_details = {:disposition => "", :notes => "undo disposition"}

    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_active_tab(patient)
      patient_dashboard_page.start_consultation
      disposition_page.provide_disposition(admit_disposition_details)
      disposition_page.provide_disposition(undo_disposition_details)
      disposition_page.go_to_dashboard_page
      patient_dashboard_page.verify_absence_of_disposition_details(admit_disposition_details)
      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_absence_of_disposition_details(admit_disposition_details)
      visit_page.navigate_to_home
      go_to_app("adt") do
        patient_search_page.verify_patient_not_found_in_to_admit_tab(patient)
      end
    end
  end
end
