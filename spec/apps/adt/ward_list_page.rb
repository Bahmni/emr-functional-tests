class Adt::WardListPage < Page

  def navigate_back_to_patient_search_page
    click_link_with_text('Patients')
  end


end