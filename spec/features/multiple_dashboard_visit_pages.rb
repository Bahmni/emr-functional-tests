require 'spec_helper'

feature "Multiple dashboard & display of patient profile details" do
  scenario "Verify display of patient profile on ADT, dashboard & Visit page" do

    name = Utils.generate_random_string
    patient_details = {:given_name => "Ram#{name}", :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :identifier =>"",
                   :house_number => "155", :gram_panchayat => "gram panchayat", :village => 'Ganiyari', :address => "155, gram panchayat, Ganiyari",
                   :caste => "hindu", :class => "OBC", :education_details => "Uneducated", :occupation => "Unemployed", :additional_info => "true",
                   :debt => "120000", :distanceFromCenter  => "15.8" ,:is_urban => "Yes", :cluster => "Semariya", :ration_card => "None", :family_income => ">=36017"}
    visit_info = {:fee => 15, :weight => 70, :height => 170, :comments => 'Billed'}

    log_in_to_app(:registration, :location => 'Registration') do
      register_new_patient_and_start_visit(:patient => patient_details, :visit_type => 'OPD')
      visit_page.should_be_current_page
      patient_details[:identifier] = visit_page.save_new_patient_visit(visit_info)
      visit_page.navigate_to_home

      go_to_app("clinical") do
      patient_search_page.view_patient_from_active_tab(patient_details[:given_name])
      patient_dashboard_page.add_dashboard("Trends")
      patient_dashboard_page.verify_current_dashboard("Trends")
      patient_dashboard_page.verify_patient_profile_information(patient_details)
      patient_dashboard_page.navigate_to_dashboard("General")

      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_current_tab("General")
      visit_page.add_tab("Discharge Summary")
      visit_page.verify_current_tab("Discharge Summary")
      visit_page.verify_patient_profile_information(patient_details)
      visit_page.find_section("Advice on Discharge")
      visit_page.navigate_to_home
      end

      go_to_app("adt") do
      patient_search_page.view_patient_from_all_tab(patient_details[:given_name])
      patient_dashboard_page.verify_patient_profile_information(patient_details)
      end
    end
  end
end
