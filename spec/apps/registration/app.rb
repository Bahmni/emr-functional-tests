class Registration::App < App
    def go_to_create_new
        click_link_with_text "Create New"
        patient_page
    end

    def register_new_patient(options)
        go_to_create_new.fill(options[:patient]).start_visit(options[:visit_type])
    end
end