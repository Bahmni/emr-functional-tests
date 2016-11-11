class Eli::PatientDetailsPage < Page
    def search_patient(patient_name)
        find('#menu_patient').click
        find('#menu_patient_add_or_edit').click
        wait_for_element_with_css_to_be_visible('#searchFirstNameID')
        find('#searchFirstNameID').set(patient_name)
        find('#searchButton').click
        sleep 2

    end

    def verify_non_empty_result
        result_size = page.all(:css , '#searchResultTable tbody tr').size
        puts result_size
        expect(result_size-1).not_to eq(0)
    end

    def logout
        find(:css , '#log-out-link').click
        page.accept_alert
    end

end

