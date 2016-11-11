module Erp::ControlHeader
    def go_to_header_section(section_name)
        page.all('.oe_topbar .oe_menu_toggler').each do |menu|
            if menu.find('.oe_menu_text').text == section_name
                menu.click
                wait_for_erploading_to_complete
                return
            end
        end
        fail
    end

    def go_to_left_section(section_name)
        page.all('.oe_leftbar .oe_menu_leaf').each do |menu|
            if menu.find('.oe_menu_text').text == section_name
                menu.click
                wait_for_erploading_to_complete
                return
            end
        end
        fail
    end
end
