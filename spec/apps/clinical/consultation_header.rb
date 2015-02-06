module Clinical::ConsultationHeader
    def go_to_observations_page
        go_to_tab "Observations"
    end

    def go_to_visit_page
        # go_to_tab "Visit"
        debugger
      find('#dashboard-link').click
      wait_for_overlay_to_be_hidden
        find(".visits i[title='Current Visit']").click
        wait_for_overlay_to_be_hidden

        # patient_dashboard_page.navigate_to_current_visit
    end

    def save
        click_on "Save"
        wait_for_overlay_to_be_hidden
        self
    end

    def go_to_tab(tab_name)
        find('.header-tabs a', :text => tab_name).click
        wait_for_overlay_to_be_hidden
    end
end