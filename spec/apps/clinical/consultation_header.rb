/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

module Clinical::ConsultationHeader
    def go_to_observations_page
        go_to_tab "Observations"
    end

    def go_to_dashboard_page
      find('#dashboard-link').click
      wait_for_overlay_to_be_hidden
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

    def go_to_adt_page
      find(:xpath,'//a[@title="Go to IPD dashboard"]').click
      wait_for_overlay_to_be_hidden
    end

end