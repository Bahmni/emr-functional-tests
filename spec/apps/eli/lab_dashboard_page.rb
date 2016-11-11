class Eli::LabDashboardPage < Page

  def navigate_to_collect_sample_page_of_patient(patient_name)
    find(:css ,'#todaySamplesToCollectListContainerId').click
    element_container='#todaySamplesToCollectListContainer'
    verify_patient_is_present(element_container, patient_name)
    click_link('Collect Sample', :match => :first) 
    wait_for_overlay_to_be_hidden
  end

  def navigate_to_enter_result_page_of_patient(patient_name)
    find(:css, '#todaySamplesCollectedListContainerId').click
    element_container='#todaySamplesCollectedListContainer'
    verify_patient_is_present(element_container, patient_name)
    find(:css,'a#result', :match=>:first).click
    wait_for_overlay_to_be_hidden
  end

  def navigate_to_validate_result_page_of_patient(patient_name)
    find(:css, '#todaySamplesCollectedListContainerId').click
    element_container='#todaySamplesCollectedListContainer'
    verify_patient_is_present(element_container, patient_name)
    find(:css,'a#validate', :match=>:first).click
    wait_for_overlay_to_be_hidden
  end


  def verify_patient_is_present(element_container , patient_name)
      search_sample_for_patient(element_container , patient_name)
      expected_patient_name = get_first_result_name(element_container)
      expect(expected_patient_name).to include(patient_name)
  end

  def search_sample_for_patient(element_container , patient_name)
    pos = position_of_column_name(element_container, 'Patient Name')
    page.all(:css , "#{element_container} input")[pos].set(patient_name)
  end

  def get_first_result_name(element_container)
    pos = position_of_column_name(element_container, 'Patient Name')
    temp = find(:css, "#{element_container} .grid-canvas .slick-row", :match => :first)
    name = temp.all(:css, '.slick-cell')[pos].text
    return name
  end

  def position_of_column_name(element_container, column_name )
    pos = 0
    page.all(:css , "#{element_container} .slick-column-name").each do |column_element|
      if column_element.text == column_name
        return pos
      end
      pos += 1
    end
  end

  def logout
    click_link('Log out')
  end
end
