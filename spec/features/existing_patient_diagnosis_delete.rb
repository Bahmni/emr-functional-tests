require 'spec_helper'

feature "exisitng patient data verification" do
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