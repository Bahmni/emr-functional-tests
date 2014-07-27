class Home::DashboardPage < Page
    def click_on_app(name)
        click_link_with_text name
        wait_for_overlay_to_be_hidden
    end
end