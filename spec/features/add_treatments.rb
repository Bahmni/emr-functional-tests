require 'spec_helper'
require 'date'

feature "add treatments for existing patients" do
  scenario "simple add treatment" do
    date = Date.today();
    patient = {:given_name => "Test AddDrugScenario", :current_visit_date => "15 Jan 15"}
    drug1 = {:drug_name => "Albendazole 400mg (Tablet)", :dose => "2", :dose_unit => "Tablet(s)", :frequency => "Twice a day", :sos => false, :start_date => date.strftime("%F"),
                :instructions => "After meals", :duration => "1", :duration_unit => "Day(s)", :drug_route => "Oral",:additional_instructions => "On medication",
                :quanity => "10"}

    drug2 = {:drug_name => "Albendazole 400mg (Tablet)", :morning_dose => "1.5", :noon_dose => "0", :night_dose => "1", :dose_unit => "Tablet(s)", :sos => true, :start_date => (date + 1).strftime("%F"),
             :instructions => "After meals", :duration => "4", :duration_unit => "Day(s)", :drug_route => "Oral",:additional_instructions => "Take medicine as required",
             :quanity => "10"}

    drug3 = {:drug_name => "Hepatitis - B 1ml (Injection)", :dose => "1", :dose_unit => "mg", :frequency => "Once a month", :sos => false, :start_date => (date + 20).strftime("%F"),
             :instructions => "In the morning", :duration => "2", :duration_unit => "Month(s)", :drug_route => "Intravenous",:additional_instructions => "Injection to be taken..",
             :quanity => "10"}

    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient[:given_name])
      patient_dashboard_page.start_consultation

      observations_page.go_to_tab("Treatment")
      treatment_page.add_new_drug(drug1, drug2, drug3)
      treatment_page.save
      treatment_page.verify_drug_on_tab("Recent", drug1, drug2, drug3)
      treatment_page.verify_drug_on_tab(patient[:current_visit_date], drug1, drug2, drug3)

      treatment_page.go_to_tab("Visit")
      visit_page.verify_new_drugs(drug1, drug2, drug3)
      visit_page.navigate_to_patient_dashboard
      patient_dashboard_page.verify_new_drugs(drug1, drug2, drug3)
      patient_dashboard_page.navigate_to_all_treatments_page
      summary_page.verify_new_drugs(drug1, drug2, drug3)

    end
  end
end