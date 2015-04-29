require 'spec_helper'

feature "new patient visit" do
  scenario "registration and consultation" do
    log_in_to_app_with_params("documentupload", "RADIOLOGY", :location => 'OPD-1' ) do
      patient_search_page.view_patient_from_active_tab('Test Radiology')
      upload_page.upload_image_for_concepts([{:image => "spec/images/sample-hand-scan.jpg", :concept_name=> 'ARM Hand AP'},
                                            {:image =>"spec/images/sample-head-scan.jpg", :concept_name=>'HEAD Nose lateral'},
                                            {:image =>"spec/images/sample-leg-scan.jpg", :concept_name=>'LEG Foot AP'}])
      upload_page.save_changes
      upload_page.verify_images_in_order(['LEG Foot AP', 'HEAD Nose lateral', 'ARM Hand AP'])

      upload_page.create_new_visit('LAB VISIT', '2015-03-01', '2015-03-02')
      upload_page.scan_image_for_new_visit("spec/images/sample-leg-scan.jpg", 'LEG Foot AP')
      upload_page.save_changes

      upload_page.expand_current_visit
      upload_page.remove_nth_image_in_current_visit(1)
      upload_page.remove_nth_image_in_current_visit(2)
      upload_page.undo_remove_nth_image_in_current_visit(1)

      upload_page.upload_image_for_concepts([{:image => "spec/images/sample-spine-scan.jpg", :concept_name=>'SPINE Lumbo-sacral AP/PA'}])
      upload_page.save_changes
      upload_page.verify_images_in_order(['SPINE Lumbo-sacral AP/PA', 'LEG Foot AP', 'ARM Hand AP'])
    end

    go_to_app("clinical") do
      sleep 2
      patient_search_page.view_patient_from_active_tab('Test Radiology')

      patient_dashboard_page.navigate_to_dashboard("General")
      patient_dashboard_page.verify_radiology_section([{:concept_name => 'SPINE Lumbo-sacral AP/PA'}, {:concept_name => 'LEG Foot AP', :image_count => 2},{:concept_name => 'ARM Hand AP'}])

      patient_dashboard_page.navigate_to_current_visit
      visit_page.verify_radiology_section([{:concept_name => 'SPINE Lumbo-sacral AP/PA'}, {:concept_name => 'LEG Foot AP'},{:concept_name => 'ARM Hand AP'}])

      visit_page.navigate_to_patient_dashboard
      patient_dashboard_page.navigate_to_visit_page('01 Mar 15 - 02 Mar 15')
      visit_page.verify_radiology_section([{:concept_name => 'LEG Foot AP'}])
    end


  end
end
