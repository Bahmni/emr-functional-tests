/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Eli::ResultPage < Page
  def enter_results_for_all_test
    page.all(:css , '.testResultValue').each do |test|
      test.set("10")
    end

    click_on('Save')
    wait_for_overlay_to_be_hidden
  end
end
