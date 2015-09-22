require 'spec_helper'
require 'date'

feature "treatments" do
  scenario "add drugs" do
    date = Date.today();
    patient = {:given_name => "Test AddDrugScenario", :current_visit_date => "15 Jan 15"}
    drug1 = {:drug_name => "Albendazole 400mg (Tablet)", :dose => "2", :dose_unit => "Tablet(s)", :frequency => "Twice a day", :sos => false, :start_date => date.strftime("%F"),
             :instructions => "After meals", :duration => "1", :duration_unit => "Day(s)", :drug_route => "Oral", :additional_instructions => "On medication",
             :quantity => "4", :quantity_units => "Tablet(s)"}

    drug2 = {:drug_name => "Albendazole 400mg (Tablet)", :morning_dose => "1.5", :noon_dose => "0", :night_dose => "1", :dose_unit => "Tablet(s)", :sos => true, :start_date => (date + 1).strftime("%F"),
             :instructions => "After meals", :duration => "4", :duration_unit => "Day(s)", :drug_route => "Oral", :additional_instructions => "Take medicine as required",
             :quantity => "10", :quantity_units => "Tablet(s)"}

    drug3 = {:drug_name => "Hepatitis - B 1ml (Injection)", :dose => "1", :dose_unit => "mg", :frequency => "Once a month", :sos => false, :start_date => (date + 20).strftime("%F"),
             :instructions => "In the morning", :duration => "2", :duration_unit => "Month(s)", :drug_route => "Intravenous", :additional_instructions => "Injection to be taken..",
             :quantity => "2", :quantity_units => "Unit(s)"}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient[:given_name])
      patient_dashboard_page.start_consultation

      observations_page.go_to_tab("Medications")
      treatment_page.add_new_drug(drug1, drug2, drug3)
      treatment_page.save
      treatment_page.verify_drug_on_tab("Recent", drug1, drug2, drug3)
      treatment_page.verify_drug_on_tab(patient[:current_visit_date], drug1, drug2, drug3)

      treatment_page.go_to_dashboard_page
      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_new_drugs(drug1, drug2, drug3)
      visit_page.navigate_to_patient_dashboard
      patient_dashboard_page.verify_new_drugs(drug1, drug2, drug3)
      patient_dashboard_page.navigate_to_all_treatments_page
      summary_page.verify_new_drugs(drug1, drug2, drug3)

    end
  end

  scenario "refill drugs" do
    date = Date.today
    patient = {:given_name => "Test RefillDrugScenario", :current_visit_date => "15 Jan 15"}
    paracetamol = {:drug_name => "Paracetamol 4.5 Litre (Syrup)", :dose => "1", :dose_unit => "ml", :frequency => "Once a month", :sos => true, :start_date => "15 Jan 15",
                   :instructions => "At bedtime", :duration => "200", :duration_unit => "Month(s)", :drug_route => "Oral", :additional_instructions => "On medication",
                   :quantity => "200", :quantity_units => "Unit(s)"}
    refilled_paracetamol = {:drug_name => "Paracetamol 4.5 Litre (Syrup)", :dose => "1", :dose_unit => "ml", :frequency => "Once a month", :sos => true, :start_date => "15 Sep 31",
                            :instructions => "At bedtime", :duration => "200", :duration_unit => "Month(s)", :drug_route => "Oral", :additional_instructions => "On medication",
                            :quantity => "200", :quantity_units => "Unit(s)"}
    merged_paracetamol = {:drug_name => "Paracetamol 4.5 Litre (Syrup)", :dose => "1", :dose_unit => "ml", :frequency => "Once a month", :sos => true, :start_date => "15 Jan 15",
                            :instructions => "At bedtime", :duration => "400", :duration_unit => "Month(s)", :drug_route => "Oral", :additional_instructions => "On medication",
                            :quantity => "400", :quantity_units => "Unit(s)"}

    ipratropium = {:drug_name => "Ipratropium Bromide Respirator Solution 15ml (Solution)", :morning_dose => "3", :noon_dose => "0", :night_dose => "0", :dose_unit => "ml", :sos => true, :start_date => "15 Jan 15",
                   :instructions => "Immediately", :duration => "3", :duration_unit => "Day(s)", :drug_route => "Intravenous", :additional_instructions => "On medication immediately..",
                   :quantity => "9", :quantity_units => "Unit(s)"}

    refilled_ipratropium = {:drug_name => "Ipratropium Bromide Respirator Solution 15ml (Solution)", :morning_dose => "3", :noon_dose => "0", :night_dose => "0", :dose_unit => "ml", :sos => true, :start_date => date.strftime("%d %b %y"),
                            :instructions => "Immediately", :duration => "3", :duration_unit => "Day(s)", :drug_route => "Intravenous", :additional_instructions => "On medication immediately..",
                            :quantity => "9", :quantity_units => "Unit(s)"}

    cytalon= {:drug_name => "Cytalon 100mg (Injection)", :dose => "1.5", :dose_unit => "mg", :frequency => "Once a month", :sos => false, :start_date => "15 Jan 30",
              :duration => "2", :duration_unit => "Month(s)", :drug_route => "Intravenous", :quantity => "3", :quantity_units => "Unit(s)"}

    refilled_cytalon= {:drug_name => "Cytalon 100mg (Injection)", :dose => "1.5", :dose_unit => "mg", :frequency => "Once a month", :sos => false, :start_date => "15 Mar 30",
                       :duration => "2", :duration_unit => "Month(s)", :drug_route => "Intravenous", :quantity => "3", :quantity_units => "Unit(s)"}

    merged_cytalon= {:drug_name => "Cytalon 100mg (Injection)", :dose => "1.5", :dose_unit => "mg", :frequency => "Once a month", :sos => false, :start_date => "15 Jan 30",
                       :duration => "4", :duration_unit => "Month(s)", :drug_route => "Intravenous", :quantity => "3", :quantity_units => "Unit(s)"}

    active_placentex = {:drug_name => "Placentex 60ml (Lotion)", :dose => "1", :dose_unit => "Unit(s)", :frequency => "Once a month", :sos => false, :start_date => "04 Feb 15", :stop_date => "04 Oct 31",
    :duration => "200", :duration_unit => "Month(s)", :drug_route => "Topical", :quantity => "200", :quantity_units => "Unit(s)"}

    new_placentex = {:drug_name => "Placentex 60ml (Lotion)", :dose => "1", :dose_unit => "mg", :frequency => "Once a day", :sos => false, :start_date => date,
                     :duration => "200", :duration_unit => "Day(s)", :drug_route => "Topical", :quantity => "200", :quantity_units => "Unit(s)"}

    refilled_placentex = {:drug_name => "Placentex 60ml (Lotion)", :dose => "1", :dose_unit => "mg", :frequency => "Once a day", :sos => false, :start_date => "04 Oct 31",
                         :duration => "200", :duration_unit => "Day(s)", :drug_route => "Topical", :quantity => "200", :quantity_units => "Unit(s)"}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient[:given_name])
      patient_dashboard_page.start_consultation

      observations_page.go_to_tab("Medications")
      treatment_page.verify_drug_on_tab("Recent", paracetamol, cytalon)
      treatment_page.refill_drug(patient[:current_visit_date], paracetamol, ipratropium, cytalon)
      treatment_page.verify_drug_on_new_prescription(refilled_cytalon, refilled_ipratropium, refilled_paracetamol)
      treatment_page.save
      treatment_page.verify_drug_on_tab(patient[:current_visit_date], paracetamol, ipratropium, cytalon, refilled_paracetamol, refilled_ipratropium, refilled_cytalon)

      treatment_page.add_new_drug(new_placentex)
      treatment_page.expect_popup(active_placentex)
      treatment_page.refill_conflicting_drug()
      treatment_page.verify_drug_on_new_prescription(refilled_placentex)
      treatment_page.save

      treatment_page.go_to_dashboard_page
      patient_dashboard_page.navigate_to_current_visit

      visit_page.verify_new_drugs(merged_paracetamol, ipratropium, refilled_ipratropium, merged_cytalon, refilled_placentex)
      visit_page.navigate_to_patient_dashboard
      patient_dashboard_page.verify_new_drugs(merged_paracetamol, ipratropium, refilled_ipratropium, merged_cytalon, refilled_placentex)
      patient_dashboard_page.navigate_to_all_treatments_page
      summary_page.verify_new_drugs(merged_paracetamol, ipratropium, refilled_ipratropium, merged_cytalon, refilled_placentex)

    end
  end
end