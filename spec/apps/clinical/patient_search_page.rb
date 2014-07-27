class Clinical::PatientSearchPage < Page
    def view_patient(patient)
        search_active_patient(patient[:given_name])
        find_active_patient(patient[:given_name]).click
        wait_for_overlay_to_be_hidden
    end

    def should_have_active_patient(patient)
        find_active_patient(patient[:given_name])
    end

    private
    def find_active_patient(text)
        find('.active-patient', :text => text)
    end

    def search_active_patient(text)
        fill_in "patientIdentifierInList", :with => text
    end
end