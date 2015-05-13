class Adt::WardListPage < Page

  def navigate_back_to_patient_search_page
    find('.back-btn .fa-users').click
  end


end