/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

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
