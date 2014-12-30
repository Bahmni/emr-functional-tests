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
        expect(observations_section).to have_content("Examination Notes #{observations[:examination_notes]}") if observations.has_key? :examination_notes
        expect(observations_section).to have_content("Sn Smoking History #{observations[:smoking_history]}") if observations.has_key? :smoking_history

        #Vitals
        expect(observations_section).to have_content("Pulse #{observations[:pulse]} /min") if observations.has_key? :pulse
        expect(observations_section).to have_content("Diastolic #{observations[:diastolic]} mm Hg") if observations.has_key? :diastolic
        expect(observations_section).to have_content("Systolic #{observations[:systolic]} mm Hg") if observations.has_key? :systolic
        expect(observations_section).to have_content("Posture #{observations[:posture]}") if observations.has_key? :posture
        expect(observations_section).to have_content("Temperature #{observations[:temperature]} F") if observations.has_key? :temperature
        expect(observations_section).to have_content("RR #{observations[:rr]} /min") if observations.has_key? :rr
        expect(observations_section).to have_content("SPO2 #{observations[:spo2]} %") if observations.has_key? :spo2

        #Second Vitals
        expect(observations_section).to have_content("Pulse #{observations[:pulse]} /min") if observations.has_key? :pulse
        expect(observations_section).to have_content("Diastolic #{observations[:diastolic]} mm Hg") if observations.has_key? :diastolic
        expect(observations_section).to have_content("Systolic #{observations[:systolic]} mm Hg") if observations.has_key? :systolic
        expect(observations_section).to have_content("Posture #{observations[:posture]}") if observations.has_key? :posture
        expect(observations_section).to have_content("Temperature #{observations[:temperature]} F") if observations.has_key? :temperature
        expect(observations_section).to have_content("RR #{observations[:rr]} /min") if observations.has_key? :rr
        expect(observations_section).to have_content("SPO2 #{observations[:spo2]} %") if observations.has_key? :spo2


        #Obstetrics
        expect(observations_section).to have_content("Fundal Height (Weeks) #{observations[:fundal_height]}") if observations.has_key? :fundal_height
        expect(observations_section).to have_content("P/A Presenting Part #{observations[:pa_presenting_part]}") if observations.has_key? :pa_presenting_part
        expect(observations_section).to have_content("FHS #{observations[:fhs]}") if observations.has_key? :fhs
        #expect(observations_section).to have_content("LMP #{observations[:lmp]}") if observations.has_key? :lmp
        expect(observations_section).to have_content("Amount of Liquor #{observations[:amountOfLiquor]}") if observations.has_key? :amountOfLiquor

        #Gynaecology
        expect(observations_section).to have_content("P/S (Per Speculum) - Cervix #{observations[:ps_perSpeculum_cervix][0]}, #{observations[:ps_perSpeculum_cervix][1]}") if observations.has_key? :ps_perSpeculum_cervix
    end


    def verify_chief_complaints(observations_section, chief_complaints)
        chief_complaints.each do |chief_complaint|
            expect(observations_section).to have_content("Chief Complaint #{chief_complaint[:name]} since #{chief_complaint[:duration][:value]} #{chief_complaint[:duration][:unit]}")
        end
    end

    def verify_existing_drugs(sections)
        sections.each do |section|
          table = page.find('.treatment-section', text: section['date'])
          section['drugs'].each do |drug|
            expect(table).to have_content(drug)
          end
        end
    end

   def navigate_to_patient_search_page
     find('.dashboard-header a', :text => "Dashboard").click
     click_on "Patients"
   end

   end