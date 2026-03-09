/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Eli::ValidationPage < Page

  def accept_results_of_all_test
    #find(:css , 'input.acceptAll').check
    check('selectAllAccept')
    click_on('Save')
    wait_for_overlay_to_be_hidden
  end

  def verify_test_count(expected_count)
    actual_count = page.all(:css , 'input.accepted').size - 1
    expect(expected_count).to eq(actual_count)
  end

end
