require 'spec_helper'

feature "new patient visit" do
    scenario "registration and consultation" do
        new_patient = {:given_name => "Ram#{Time.now.to_i}", :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari'}
        visit_info = {:fee => 15, :weight => 70, :height => 170, :comments => 'Billed'}
        chief_complaints = [{:name => 'Cough', :duration => {:value => 2, :unit => 'Days'}, :coded => false},
                            {:name => 'Fever', :duration => {:value => 3, :unit => 'Weeks'}, :coded => false}]
        history_and_examinations = {:chief_complaints => chief_complaints, :history_notes => "Smoking, Drinking", :examination_notes => "Concise text notes", :smoking_history => "No" }
        vitals = {:pulse => 72, :diastolic => 75, :systolic => 115, :posture => 'Supine', :temperature => 100, :rr => 18, :spo2 => 99}
        second_vitals = {:pulse => 75, :diastolic => 80, :systolic => 120, :posture => 'Sitting', :temperature => 105, :rr => 25, :spo2 => 95}
        obstetrics = { :fundal_height => "4", :pa_presenting_part => "Breech", :fhs => "Absent", :lmp => "29/07/2014", :amountOfLiquor => "twice per day"}
        gynaecology = {:ps_perSpeculum_cervix => ["Growth", "VIA +ve"] }
        diagnosis = {:index => 0, :name => 'cold', :order => 'PRIMARY', :certainty => 'PRESUMED'}
        nutritional_values = {:weight => 70, :height => 170, :bmi => 24.22, :bmi_status => 'Normal'}


        log_in_to_app(:registration, :location => 'Registration') do
            register_new_patient_and_start_visit(:patient => new_patient, :visit_type => 'OPD')
            visit_page.should_be_current_page
            visit_page.save_new_patient_visit(visit_info)
        end

        log_in_to_app(:clinical, :location => 'OPD-1') do
            patient_search_page.view_patient_from_active_tab(new_patient[:given_name])
            patient_dashboard_page.start_consultation
            diagnosis_page.add_non_coded_diagnosis(diagnosis)

            observations_page.fill_history_and_examinations_section(history_and_examinations)
            observations_page.fill_vitals_section(vitals)
            observations_page.fill_second_vitals_section(second_vitals)
            observations_page.fill_obstetrics_section(obstetrics)
            observations_page.fill_gynaecology_section(gynaecology)
            observations_page.save
            observations_page.go_to_dashboard_page
            patient_dashboard_page.verify_nutritional_values(nutritional_values, "Nutritional-Values")
            patient_dashboard_page.verify_observations_on_all_details_page(nutritional_values, "Nutritional-Values")

            patient_dashboard_page.verify_vitals(vitals, "Vitals")
            patient_dashboard_page.verify_observations_on_all_details_page(vitals, "Vitals")

            patient_dashboard_page.verify_second_vitals(second_vitals, "Second-Vitals")
            patient_dashboard_page.verify_observations_on_all_details_page(second_vitals, "Second-Vitals")

            patient_dashboard_page.verify_history_and_examination_values(history_and_examinations, "History-and-Examinations")
            patient_dashboard_page.verify_observations_on_all_details_page(history_and_examinations, "History-and-Examinations")

            patient_dashboard_page.verify_gynaecology_values(gynaecology, "Gynaecology")
            patient_dashboard_page.verify_observations_on_all_details_page(gynaecology, "Gynaecology")

            patient_dashboard_page.verify_obstetrics_values(obstetrics, "Obstetrics")
            patient_dashboard_page.verify_observations_on_all_details_page(obstetrics, "Obstetrics")

            patient_dashboard_page.navigate_to_current_visit
            visit_page.verify_observations(nutritional_values)
            visit_page.verify_observations(vitals)
            visit_page.verify_observations(second_vitals)
            visit_page.verify_observations(history_and_examinations)
            visit_page.verify_observations(obstetrics)
            visit_page.verify_observations(gynaecology)
        end
    end

    scenario "Verify Uploading Consultation images" do
      new_patient = {:given_name => "Ram#{(0...5).map { (97 + rand(26)).chr }.join}", :family_name => 'Singh', :gender => 'Male', :age => {:years => "40"}, :village => 'Ganiyari'}
      log_in_to_app(:registration, :location => 'Registration') do
        register_new_patient(:patient => new_patient, :visit_type => 'OPD')
      end

      log_in_to_app(:clinical, :location => 'OPD-1') do
        patient_search_page.view_patient_from_active_tab(new_patient[:given_name ])
        patient_dashboard_page.start_consultation
        observations_page.add_consultation_images_in_history_and_examinations_section([{:image => "spec/images/sample-hand-scan.jpg"},
                                                                                       {:image =>"spec/images/sample-head-scan.jpg"}])
        observations_page.save
        observations_page.verify_saved_images(2)
        observations_page.delete_existing_images
        observations_page.undo_delete
        observations_page.add_consultation_images([{:image =>"spec/images/sample-leg-scan.jpg"},
                                                   {:image =>"spec/images/sample-spine-scan.jpg"}])
        observations_page.save
        observations_page.verify_saved_images(3)
      end

    end
end