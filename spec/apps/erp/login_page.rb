/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Erp::LoginPage < Page

    def login
        fill_in 'login', :with => Settings.erp_default_username
        fill_in 'password', :with =>  Settings.erp_default_password
        select 'openerp', :from => 'db'
        click_on 'Log in'
        wait_for_erploading_to_complete
    end
end
