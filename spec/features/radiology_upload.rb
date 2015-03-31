require 'spec_helper'

feature "new patient visit" do
  scenario "registration and consultation" do
    log_in_to_app_with_params("documentupload", "RADIOLOGY", :location => 'OPD-1' ) do
      patient_search_page.view_patient_from_active_tab('Test Radiology')

      attach_file('image-document-upload', File.expand_path("spec/images/sample-hand-scan.jpeg"))
      fill_in "image0", :with => 'ARM Hand AP'
      find(".ui-menu-item").click

      attach_file('image-document-upload', File.expand_path("spec/images/sample-head-scan.jpg"))
      fill_in "image0", :with => 'HEAD Nose lateral'
      find(".ui-menu-item").click

      attach_file('image-document-upload', File.expand_path("spec/images/sample-leg-scan.jpg"))
      fill_in "image0", :with => 'LEG Foot AP'
      find(".ui-menu-item").click

      find(".icon-save", :visible => true).click
      expect(find(:xpath, '//input[contains(@name,"image0")]').value).to eq('LEG Foot AP')
      expect(find(:xpath, '//input[contains(@name,"image1")]').value).to eq('HEAD Nose lateral')
      expect(find(:xpath, '//input[contains(@name,"image2")]').value).to eq('ARM Hand AP')

      first(".icon-plus-sign", :visible => true).click
      select 'LAB VISIT'
      fill_in 'endDate', :with => '2015-03-02'
      fill_in 'startDate', :with => '2015-03-01'
      attach_file('file-browse', File.expand_path("spec/images/sample-leg-scan.jpg"))
      fill_in 'image0', :with => 'LEG Foot AP', :visible => true
      find(".ui-menu-item").click
      find(".icon-save", :visible => true).click

      find(".icon-star").click
      find_by_id('remove-image0', :visible => true).click
      find_by_id('remove-image1', :visible => true).click
      find_by_id('remove-image0', :visible => true).click

      attach_file('image-document-upload', File.expand_path("spec/images/sample-spine-scan.jpg"), :visible => true)
      fill_in "image0", :with => 'SPINE Lumbo-sacral AP/PA', :visible => true
      find(".ui-menu-item").click
      find(".icon-save", :visible => true).click

      expect(find(:xpath, '//input[contains(@name,"image0")]', :visible => true).value).to eq('SPINE Lumbo-sacral AP/PA')
      expect(find(:xpath, '//input[contains(@name,"image1")]', :visible => true).value).to eq('LEG Foot AP')
      expect(find(:xpath, '//input[contains(@name,"image2")]', :visible => true).value).to eq('ARM Hand AP')
    end

    go_to_app("clinical") do
      sleep 2
      patient_search_page.view_patient_from_active_tab('Test Radiology')
      patient_dashboard_page.navigate_to_dashboard("General")

      radiology_section = find(".dashboard-radiology-section")
      expect(radiology_section).to have_content("ARM Hand AP")
      expect(radiology_section).to have_content("SPINE Lumbo-sacral AP/PA")
      expect(radiology_section).to have_content("LEG Foot AP")

      patient_dashboard_page.navigate_to_current_visit
      radiology_section = find(".radiology-investigations")
      expect(radiology_section).to have_content("ARM Hand AP")
      expect(radiology_section).to have_content("SPINE Lumbo-sacral AP/PA")
      expect(radiology_section).to have_content("LEG Foot AP")

      visit_page.navigate_to_patient_dashboard
      patient_dashboard_page.navigate_to_visit_page('1 Mar 15')
      radiology_section = find(".radiology-investigations")
      expect(radiology_section).to have_content("LEG Foot AP")
    end

  end
end
