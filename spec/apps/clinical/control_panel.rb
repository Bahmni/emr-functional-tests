/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

module Clinical::ControlPanel

  def open_side_panel
    find('button.toggle-patient').click
  end

  def navigate_to_home
    open_side_panel
    find(".bahmni-home a").click
    wait_for_overlay_to_be_hidden
  end

end