require 'spec_helper'
require 'date'

feature "add treatments for existing patients" do
  scenario "simple add treatment" do
    date = Date.today();
    patient = {:given_name => "Test AddDrugScenario"}
    drug1 = {:drug_name => "Hepatitis - B 1ml (Injection)", :dose => "1", :dose_unit => "mg", :frequency => "Twice a day", :sos => false, :start_date => date.strftime("%F"),
                :instructions => "After meals", :duration => "1", :duration_unit => "Day(s)", :drug_route => "Intravenous",:additional_instructions => "Testing simple add scenario",
                :quanity => "10"}
    drug2 = {:drug_name => "Hepatitis - B 1ml (Injection)", :dose => "1", :dose_unit => "mg", :frequency => "Once a day", :sos => true, :start_date => (date + 1).strftime("%F"),
             :instructions => "After meals", :duration => "1", :duration_unit => "Day(s)", :drug_route => "Intravenous",:additional_instructions => "Testing simple add scenario",
             :quanity => "10"}

    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient[:given_name])
      patient_dashboard_page.start_consultation

      observations_page.go_to_tab("Treatment")

      treatment_page.fill_new_drug(drug1)
      treatment_page.fill_new_drug(drug2)
      treatment_page.save.confirm_saved

      treatment_page.verify_drug_on_tab("Recent", drug1)
      treatment_page.verify_drug_on_tab("Recent", drug2)
      treatment_page.verify_drug_on_tab("15 Jan 15", drug1)
      treatment_page.verify_drug_on_tab("15 Jan 15", drug2)
    end
  end
end