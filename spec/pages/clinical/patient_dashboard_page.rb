class Clinical::PatientDashboardPage < Page
    def verify_visit_vitals_info(vitals)
        vitals_section = find('.dashboard-section h2', :text => 'Vitals').parent
        expect(vitals_section).to have_content("BMI #{vitals[:bmi]}") if vitals.has_key? :bmi
        expect(vitals_section).to have_content("BMI STATUS #{vitals[:bmi_status]}") if vitals.has_key? :bmi_status
        expect(vitals_section).to have_content("HEIGHT #{vitals[:height]}") if vitals.has_key? :height
        expect(vitals_section).to have_content("WEIGHT #{vitals[:weight]}") if vitals.has_key? :weight
    end

    def start_consultation
    	find("a.confirm", :text => 'Consultation').click
    end
end