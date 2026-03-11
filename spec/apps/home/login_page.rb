/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Home::LoginPage < Page
    set_url '/bahmni/home/#login'

    def login(credentials)
        fill_in 'Username', :with => credentials[:username] || Settings.default_username
        fill_in 'Password', :with => credentials[:password] || Settings.default_password
        select credentials[:location], :from => 'Location'
        click_on 'Login'
        wait_for_overlay_to_be_hidden
    end
end