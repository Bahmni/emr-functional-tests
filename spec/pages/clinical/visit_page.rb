class Clinical::VisitPage < Page
    include Clinical::ConsultationHeader

    def verify_observations(observations)
        observations_section = find('section.observation')
        expect(observations_section).to have_content("BMI #{observations[:bmi]}") if observations.has_key? :bmi
        expect(observations_section).to have_content("BMI STATUS #{observations[:bmi_status]}") if observations.has_key? :bmi_status
        expect(observations_section).to have_content("HEIGHT #{observations[:height]}") if observations.has_key? :height
        expect(observations_section).to have_content("WEIGHT #{observations[:weight]}") if observations.has_key? :weight
    end
end