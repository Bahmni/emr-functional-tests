module Clinical::ConsultationHeader
    def go_to_observations
    	click_link_with_text "Observations"
    end

    def save
    	click_on "Save"
    	self
    end

    def confirm_saved
    	expect(page).to have_selector('.info-message', :text => 'Saved')
    end
end