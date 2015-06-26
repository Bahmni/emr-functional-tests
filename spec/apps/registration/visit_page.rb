class Registration::VisitPage < Page
    set_url '/bahmni/registration/#/patient/{patient_id}/visit'

    def save_new_patient_visit(visit_info)
        fill_in("REGISTRATION FEES", :with => visit_info[:fee])
        fill_in("WEIGHT", :with => visit_info[:weight])  if visit_info.has_key? :weight
        fill_in("HEIGHT", :with => visit_info[:height])  if visit_info.has_key? :height
        fill_in("COMMENTS", :with => visit_info[:comments]) if visit_info.has_key? :comments
        click_on("Save")
        wait_for_overlay_to_be_hidden
    end

  def navigate_to_home
        find('.fa-home').click
        wait_for_overlay_to_be_hidden
  end

end