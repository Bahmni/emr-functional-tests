class Adt::WardListPage < Page

  def navigate_back_to_patient_search_page
    find('#adtHomeBackLink').click
    wait_for_overlay_to_be_hidden
  end

  def assign_or_transfer_bed(assign_or_transfer,ward_name)
    #expand_ward_section('General Ward')
    bed_details=page.find('ward.ng-isolate-scope',:text=>ward_name).all('ul.bed-assignment-inner-wrapper li.available')[0].first('span').text
    page.find('ward.ng-isolate-scope',:text=>ward_name).all('ul.bed-assignment-inner-wrapper li.available')[0].click
    wait_for_element_with_css_to_be_visible("a.#{assign_or_transfer}")
    page.find("a.#{assign_or_transfer}").click
    sleep 0.1
    wait_for_overlay_to_be_hidden
    return bed_details
  end

  def available_bed_count(ward_name)
    ward_text=page.find('.section-title-text',:text=>ward_name).text
    return ward_text.split('|')[1].gsub(/[a-zA-Z :)]/,'').to_i
  end

  def expand_ward_section(ward_section)
    #if ! page.find('h2',:text=>ward_section).visible?
      page.find('.section-title-text',:text=>ward_section).click
      wait_for_element_with_css_to_be_visible('ul.bed-assignment-inner-wrapper')
    #end
  end

  def validate_bed_count_after_assign(available_beds_before_assign,available_beds_after_assign,expected)
    expect(available_beds_before_assign-available_beds_after_assign).to eq(expected)
  end

  def verify_bed_details_and_notes(patient_name,admit_details)
    patient_bed_admit_details= page.first('tr',:text=>patient_name).text
    expect(patient_bed_admit_details).to include(admit_details[:notes])
    expect(patient_bed_admit_details).to include(admit_details[:bed_detail])
  end

  def goto_patient_dashboard_from_id_link(patient_name)
    page.first('tr',:text=>patient_name).find('a').click
    wait_for_overlay_to_be_hidden
  end

end