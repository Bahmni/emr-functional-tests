class Clinical::ObservationsPage < Page
	include Clinical::ConsultationHeader

    def fill_history_and_examinations_section(details)
        fill_in "History Notes", :with => details[:history_notes]
    end
end