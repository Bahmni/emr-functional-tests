class Home::DashboardPage < Page
    def click_on_app(name)
        click_icon_link name
        wait_for_overlay_to_be_hidden
    end
end