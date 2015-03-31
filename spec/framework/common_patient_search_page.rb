class CommonPatientSearchPage < Page

    def view_patient_from_all_tab(patient)
      search_patient_in_all_tab( patient)
    end

    def view_patient_from_active_tab(patient)
      search_patient_in_tab("Active", patient)
    end

    def search_patient_in_all_tab(patient)
      go_to_tab("All")
      fill_in "patientIdentifier", :with => patient
      find_button('Search').click
      wait_for_overlay_to_be_hidden
    end

    def search_patient_in_tab(tab, patient)
      go_to_tab(tab)
      search_patient(patient)
    end

    def go_to_tab tab
      click_on tab
      wait_for_overlay_to_be_hidden
    end

    def search_patient(patient)
      fill_in "patientIdentifier", :with => patient
      find('.active-patient', :text => patient).click
      wait_for_overlay_to_be_hidden
    end
end