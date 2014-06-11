class Registration::PatientSearchPage < Page
	def go_to_create_new
		find('a', :text => "Create New").click
	end
end