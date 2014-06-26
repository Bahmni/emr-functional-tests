class Clinical::VisitPage < Page
    include Clinical::ConsultationHeader

    def verify_observations(observations)
        observations_section = find('section.observation')
        expect(observations_section).to have_content("BMI #{observations[:bmi]}") if observations.has_key? :bmi
        expect(observations_section).to have_content("BMI STATUS #{observations[:bmi_status]}") if observations.has_key? :bmi_status
        expect(observations_section).to have_content("HEIGHT #{observations[:height]}") if observations.has_key? :height
        expect(observations_section).to have_content("WEIGHT #{observations[:weight]}") if observations.has_key? :weight

        #History and Examination
        verify_chief_complaints(observations_section, observations[:chief_complaints]) if observations.has_key? :chief_complaints
        expect(observations_section).to have_content("History Notes #{observations[:history_notes]}") if observations.has_key? :history_notes

        #Vitals
        expect(observations_section).to have_content("Pulse #{observations[:pulse]} /min") if observations.has_key? :pulse
        expect(observations_section).to have_content("Diastolic #{observations[:diastolic]} mm Hg") if observations.has_key? :diastolic
        expect(observations_section).to have_content("Systolic #{observations[:systolic]} mm Hg") if observations.has_key? :systolic
        expect(observations_section).to have_content("Temperature #{observations[:temperature]} F") if observations.has_key? :temperature
        expect(observations_section).to have_content("RR #{observations[:rr]} /min") if observations.has_key? :rr
        expect(observations_section).to have_content("SPO2 #{observations[:spo2]} %") if observations.has_key? :spo2
    end


    def verify_chief_complaints(observations_section, chief_complaints)
        chief_complaints.each do |chief_complaint|
            label = chief_complaint[:coded] ? "Chief Complaint" : "Non-Coded Chief Complaint"
            expect(observations_section).to have_content("#{label} #{chief_complaint[:name]} since #{chief_complaint[:duration][:value]} #{chief_complaint[:duration][:unit]}")
        end
    end
end