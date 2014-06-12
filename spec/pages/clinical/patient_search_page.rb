class Clinical::PatientSearchPage < Page
	def show_active_patient(text)
		fill_in "patientIdentifierInList", :with => text
		active_patient(text).click
		wait_for_overlay_to_be_hidden
	end

	def should_have_patient(text)
		active_patient(text)
	end

	private
	def active_patient(text)
		find('.active-patient', :text => text)
	end
end