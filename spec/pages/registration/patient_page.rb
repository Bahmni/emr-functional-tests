class Registration::PatientPage < Page
    def fill(patient)
        fill_in 'givenName', :with => patient[:given_name]
        fill_in 'familyName', :with => patient[:family_name]
        select patient[:gender], :from => 'gender'
        fill_in 'ageYears', :with => patient[:age][:years]
        fill_in 'Village', :with => patient[:village]
        self
    end

    def start_visit(type)
        click_on "Start #{type} visit"
        wait_for_overlay_to_be_hidden
    end
end