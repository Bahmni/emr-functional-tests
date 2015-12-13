require 'spec_helper'

feature "admit patient" do
  scenario "verify patient admit with no open visit" do

    patient1 = "Test NoOpenVisit Scenario"
    admit_details = {:action => "Admit Patient", :notes => "Admit the patient"}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient1)
      patient_dashboard_page.verify_absence_of_start_consultation_link
      patient_dashboard_page.verify_absence_of_current_visit
      end
      go_to_app(:InPatient) do
        patient_search_page.view_patient_from_all_tab(patient1)
        patient_dashboard_page.perform_admit_action(admit_details)
       end
      go_to_app(:Clinical) do
        patient_search_page.view_patient_from_active_tab(patient1)
        patient_dashboard_page.verify_presence_of_start_consultation_link
        patient_dashboard_page.verify_presence_of_current_visit
        patient_dashboard_page.verify_visit_type("IPD")
      end
  end

  scenario "verify patient Assign/Transfer bed and IPD dashboard details" do

    name = Utils.generate_random_string(4)
    new_patient = {:given_name => "Ram#{name}", :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari'}
    admit_details = {:action => "Admit Patient", :notes => "Admit the patient",:ward=>'General Ward',:bed_detail=>''}
    transfer_details = {:action => "Transfer Patient", :notes => "",:ward=>'General Ward',:bed_detail=>''}
    discharge_details = {:action => "Discharge Patient", :notes => "Discharge the patient",:ward=>'General Ward'}

    log_in_to_app(:Registration, :location => 'Registration') do
      register_new_patient_and_start_visit(:patient => new_patient, :visit_type => 'OPD')
      sleep 1
    end

    log_in_to_app(:InPatient, :location => 'OPD-1') do

      patient_search_page.view_patient_from_all_tab(new_patient[:given_name])
      patient_dashboard_page.perform_admit_action(admit_details)
      available_bed_count_before_admit= ward_list_page.available_bed_count(admit_details[:ward])

      ward_list_page.expand_ward_section(admit_details[:ward])
      admit_details[:bed_detail]= ward_list_page.assign_or_transfer_bed('assign',admit_details[:ward])
      admit_details[:bed_detail]=ward_list_page.assign_or_transfer_bed('transfer',admit_details[:ward])

      available_bed_count_after_admit = ward_list_page.available_bed_count(admit_details[:ward])
      ward_list_page.validate_bed_count_after_assign(available_bed_count_before_admit,available_bed_count_after_admit,1)

      ward_list_page.navigate_back_to_patient_search_page

      ward_list_page.verify_bed_details_and_notes(new_patient[:given_name],admit_details)
      ward_list_page.goto_patient_dashboard_from_id_link(new_patient[:given_name])
      patient_dashboard_page.verify_adt_admission_details(admit_details)

      patient_dashboard_page.perform_transfer_action(transfer_details)
      #available_bed_count_before_transfer_to_another_ward= ward_list_page.available_bed_count(transfer_details[:ward])

      transfer_details[:bed_detail]=ward_list_page.assign_or_transfer_bed('transfer',transfer_details[:ward])
      available_beds_after_transfer = ward_list_page.available_bed_count(transfer_details[:ward])
      ward_list_page.validate_bed_count_after_assign(available_bed_count_after_admit,available_beds_after_transfer,0)

      ward_list_page.navigate_back_to_patient_search_page

      ward_list_page.verify_bed_details_and_notes(new_patient[:given_name],transfer_details)
      ward_list_page.goto_patient_dashboard_from_id_link(new_patient[:given_name])
      patient_dashboard_page.verify_adt_admission_details(transfer_details)

      patient_dashboard_page.perform_discharge_action(discharge_details)

      available_beds_after_discharge= ward_list_page.available_bed_count(discharge_details[:ward])
      ward_list_page.validate_bed_count_after_assign(available_beds_after_discharge,available_beds_after_transfer,1)

    end

  end
end
