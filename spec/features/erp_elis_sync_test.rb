require 'spec_helper'
require 'date'
feature "erp and elis test" do
  xscenario "erp and elis test" do # "xscenario" to be renamed to"scenario" after setting up erp and elis in environment
        name = Utils.generate_random_string(6)
        date = Date.today()
        patient = {:given_name => "Ram#{name}", :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari'}
        visit_info = {:fee => 15, :weight => 70, :height => 170, :comments => 'Billed'}
        drug1 = {:drug_name => "Albendazole 400mg (Tablet)", :dose => "2", :dose_unit => "Tablet(s)", :frequency => "Twice a day", :sos => false, :start_date => date.strftime("%F"),
                 :instructions => "After meals", :duration => "1", :duration_unit => "Day(s)", :drug_route => "Oral", :additional_instructions => "On medication",
                 :quantity => "4", :quantity_units => "Tablet(s)"}

        drug2 = {:drug_name => "Hepatitis - B 1ml (Injection)", :dose => "1", :dose_unit => "mg", :frequency => "Once a month", :sos => false, :start_date => (date + 20).strftime("%F"),
                 :instructions => "In the morning", :duration => "2", :duration_unit => "Month(s)", :drug_route => "Intravenous", :additional_instructions => "Injection to be taken..",
                 :quantity => "2", :quantity_units => "mg", :quantity_in_erp => "1"}

        log_in_to_app(:Registration, :location => 'Registration') do
            register_new_patient_and_start_visit(:patient => patient, :visit_type => 'OPD')
            visit_page.should_be_current_page
            visit_page.save_new_patient_visit(visit_info)
        end

        log_in_to_app(:Clinical, :location => 'OPD-1') do
            patient_search_page.view_patient_from_all_tab(patient[:given_name])
            patient_dashboard_page.start_consultation
            observations_page.go_to_tab("Medications")
            treatment_page.add_new_drug(drug1, drug2)
            treatment_page.save


            observations_page.go_to_tab("Orders")
            orders_page.select_order('Laboratory', 'Blood', 'DLC')
            orders_page.save
        end
        
        sleep 15
       
        log_in_to_erp do
             sales_page.get_quotation_for_patient(patient[:given_name])
             quotations_page.verify_drug_info(drug1,drug2)
        end


        log_in_to_elis do
            lab_dashboard_page.navigate_to_collect_sample_page_of_patient(patient[:given_name])
            add_sample_page.generate_accession_number_and_save
            lab_dashboard_page.navigate_to_enter_result_page_of_patient(patient[:given_name])
            result_page.enter_results_for_all_test
            lab_dashboard_page.navigate_to_validate_result_page_of_patient(patient[:given_name])
            validation_page.accept_results_of_all_test
          end
        log_in_to_app(:Clinical , :location => 'Registration') do
            patient_search_page.view_patient_from_active_tab(patient[:given_name])
            patient_dashboard_page.verify_lab_results
        end
        
   end
end


