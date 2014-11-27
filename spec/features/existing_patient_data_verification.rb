require 'spec_helper'

feature "exisitng patient data verification" do
  scenario "verify drug data" do
    patient1 = "Test DrugDataOne" # Has active drugs from Visit1 and Visit2. Last Prescription section shows drugs from Visit2. Visit3 and Visit4 has no treatment data
    patient2 = "Test DrugDataTwo" # Has active drugs from latest Visit -Visit2. Has drugs of various forms

    data = YAML.load_file(File.expand_path("../../data.yml", __FILE__))
    patient1_data = data["Test DrugDataOne"]
    patient2_data = data["Test DrugDataTwo"]

  log_in_to_app(:clinical, :location => 'OPD-1') do
    patient_search_page.view_patient_from_all_tab(patient1)
    #patient_dashboard_page.verify_existing_drugs(patient1_data["dashboard"])
    patient_dashboard_page.verify_drugs_all_treatments_page(patient1_data["all_treatments_page"])
    patient_dashboard_page.navigate_to_visit_from_side_panel(patient1_data["first_visit_date"])
    visit_page.verify_existing_drugs(patient1_data["first_visit"])
    patient_dashboard_page.navigate_to_visit_from_side_panel(patient1_data["second_visit_date"])
    visit_page.verify_existing_drugs(patient1_data["second_visit"])

    visit_page.navigate_to_patient_search_page
    patient_search_page.view_patient_from_all_tab(patient2)
    #patient_dashboard_page.verify_existing_drugs(patient2_data["dashboard"])
    patient_dashboard_page.verify_drugs_all_treatments_page(patient2_data["all_treatments_page"])
    patient_dashboard_page.navigate_to_visit_from_side_panel(patient2_data["latest_visit_date"])
    visit_page.verify_existing_drugs(patient2_data["latest_visit"])
  end
end
end