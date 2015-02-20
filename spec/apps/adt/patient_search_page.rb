class Adt::PatientSearchPage < Page

    def view_patient_from_all_tab(patient)
      search_patient_in_all_tab( patient)
    end

    def view_patient_from_to_admit_tab(patient)
      search_patient_in_tab("To Admit", patient)
      end

    def view_patient_from_to_discharge_tab(patient)
      search_patient_in_tab("To Discharge", patient)
      end

    def view_patient_from_admitted_tab(patient)
      search_patient_in_tab("Admitted", patient)
    end

    def verify_patient_not_found_in_to_admit_tab(patient)
       go_to_tab("To Admit")
       fill_in "patientIdentifier", :with => patient
       if(!assert_no_selector(".active-patient"))
         expect(find('.active-patient')).to have_no_content(patient)
       end
    end

    private

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