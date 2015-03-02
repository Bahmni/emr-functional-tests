class Registration::PatientPage < Page
    def fill(patient)
        fill_in 'givenName', :with => patient[:given_name]
        fill_in 'familyName', :with => patient[:family_name]
        select patient[:gender], :from => 'gender'
        fill_in 'ageYears', :with => patient[:age][:years]
        fill_in 'Village', :with => patient[:village]
        fill_in 'House No., Street', :with => patient[:house_number] if patient.has_key? :house_number
        fill_in 'Gram Panchayat', :with => patient[:gram_panchayat] if patient.has_key? :gram_panchayat
        fill_in 'Caste', :with => patient[:caste] if patient.has_key? :caste
        select(patient[:class], :from => "class") if patient.has_key? :class
        select(patient[:education_details], :from => "education") if patient.has_key? :education_details
        select(patient[:occupation], :from => "occupation") if patient.has_key? :occupation
        if (patient.has_key? :additional_info) && (patient[:additional_info] == "true")
        click_link_with_text "Additional Patient Information"
        fill_in 'debt (in Rs)', :with => patient[:debt] if patient.has_key? :debt
        fill_in 'distanceFromCenter (in km)', :with => patient[:distanceFromCenter] if patient.has_key? :distanceFromCenter
        check 'isUrban'
        select(patient[:cluster], :from => "cluster") if patient.has_key? :cluster
        select(patient[:ration_card], :from => "RationCard") if patient.has_key? :ration_card
        select(patient[:family_income], :from => "familyIncome") if patient.has_key? :family_income
        end
        self
    end

    def start_visit(type)
        click_on "Start #{type} visit"
        wait_for_overlay_to_be_hidden
    end
end