class Clinical::PatientSearchPage < Page
	def show_active_patient(patient)
		search_text = patient[:given_name]
		fill_in "patientIdentifierInList", :with => search_text
		active_patient(search_text).click
		wait_for_overlay_to_be_hidden
	end

	def should_have_patient(patient)
		active_patient(patient[:given_name])
	end

	private
	def active_patient(text)
		find('.active-patient', :text => text)
	end
end