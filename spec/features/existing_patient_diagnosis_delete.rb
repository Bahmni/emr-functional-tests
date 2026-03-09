/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

require 'spec_helper'

feature "exisitng patient diagnosis deletion" do
  scenario "verify deletion of diagnosis" do
    patient = {:given_name => "PatientWith DeletableDiagnosis"} # Is very ill. Has been diagnosed with "Similar Diagnosis", "Giardiasis" and "Amebiasis" among others
    diagnosis = {:index => 0, :name => "UniqueCold#{Time.now.to_i}", :order => 'PRIMARY', :certainty => 'PRESUMED'}

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_active_tab(patient[:given_name])
      patient_dashboard_page.start_consultation

      diagnosis_page.add_non_coded_diagnosis(diagnosis)
      diagnosis_page.save
      diagnosis_page.delete_diagnosis(diagnosis)
    end
  end
end