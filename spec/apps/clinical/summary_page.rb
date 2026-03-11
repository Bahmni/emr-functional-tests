/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Clinical::SummaryPage < Common::DisplayControlsPage

  TREATMENT_SECTION = "#treatment-summary"

  def verify_existing_drugs(sections)
    sections.each do |section|
      table = page.find(TREATMENT_SECTION, :text => section['visit_date'])
      section['drugs'].each do |drug|
        expect(table).to have_content(drug)
      end
    end
    find('.ngdialog-theme-default.ng-dialog-all-details-page .ngdialog-close').click
  # click_on "Back"
  end

  def verify_new_drugs(*drugs)
    verify_drug_details(TREATMENT_SECTION, *drugs)
  end

end