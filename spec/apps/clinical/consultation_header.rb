module Clinical::ConsultationHeader
    def go_to_observations_page
        go_to_tab "Observations"
    end

    def go_to_visit_page
        # go_to_tab "Visit"
      find('.dashboard-header a', :text => "Dashboard").click
      wait_for_overlay_to_be_hidden
      patient_search_page.navigate_to_current_visit
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