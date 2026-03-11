/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

module CapybaraDslExtensions
    def click_link_with_text(text)
        find('a', :text => text).click
    end

    def current_path_with_fragment
      current_url.sub(%r{.*?://},'')[%r{[/\?\#].*}] || '/'
    end

    def wait_until
        Timeout.timeout(Capybara.default_wait_time) { value = yield until value }
    end

    def click_button_with_text(text, index=1)
      find(:xpath, "(//button[text()='#{text}'])[#{index}]").click
    end

end