class Registration::App < Page
	def go_to_create_new
		click_icon_link "Create New"
		Registration::PatientPage.new
	end

	def register_new_patient(patient)
		go_to_create_new.fill(patient)
	end
end