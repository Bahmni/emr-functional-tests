class Registration::App < App
    def go_to_create_new
        click_link_with_text "Create New"
        patient_page
    end

    def register_new_patient_and_start_visit(options)
        go_to_create_new.fill(options[:patient]).start_visit_type(options[:visit_type])
    end

    def register_new_patient(options)
      go_to_create_new.fill(options[:patient]).save
    end

    def verify_details_after_update_village(village)
      patient_page.verify_update_village(village)
    end

    def verify_details_after_update_age(age)
      patient_page.verify_update_age(age)
    end

    def verify_details_in_patient_page(patient_id,options)
      patient_search_page.search_patient_with_id(patient_id)
      patient_page.verify_all_fields(options)
    end

    def verify_search_by_name_results(options)
      patient_search_page.search_patient_with_name(options[:given_name])
      patient_search_page.verify_search_by_name_result(options)
      goto_search_page
    end

    def verify_back_button_in_visit_page(options)
      patient_page.start_visit_type(options[:visit_type])
      visit_page.goto_patient_page
    end

    def save_existing_patient_visit(visit_info)
      patient_page.enter_visit_page
      visit_page.save_new_patient_visit(visit_info)
    end

    def goto_search_page
      click_link_with_text "Search"
    end

end