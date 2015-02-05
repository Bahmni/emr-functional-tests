class Clinical::ObservationsPage < Page
    include Clinical::ConsultationHeader

    def fill_history_and_examinations_section(details)
        wait_for_overlay_to_be_hidden
        expand_section "History and Examination"
        fill_chief_complaints details[:chief_complaints] if details.has_key? :chief_complaints
        fill_in "History Notes", :with => details[:history_notes] if details.has_key? :history_notes
        fill_in "Examination Notes", :with => details[:examination_notes] if details.has_key? :examination_notes
        click_on(details[:smoking_history]) if details.has_key? :smoking_history
    end

    def fill_vitals_section(vitals)
        expand_section "Vitals"
        fill_vitals_data(get_section('Vitals'), vitals)
    end

    def fill_second_vitals_section(vitals)
        expand_section "Second Vitals"
        fill_vitals_data(get_section("Second Vitals"), vitals)
    end

    def fill_obstetrics_section(obstetrics)
        expand_section("Obstetrics")
        fill_in 'Fundal Height', :with => obstetrics[:fundal_height]  if obstetrics.has_key? :fundal_height
        click_on(obstetrics[:pa_presenting_part]) if obstetrics.has_key? :pa_presenting_part
        click_on(obstetrics[:fhs]) if obstetrics.has_key? :fhs
        #fill_in 'LMP', :with => "23072014"
        fill_in 'Amount of Liquor', :with => obstetrics[:amountOfLiquor] if obstetrics.has_key? :amountOfLiquor
    end

    def fill_gynaecology_section(gynaecology)
        expand_section("Gynaecology")
        gynaecology[:ps_perSpeculum_cervix].each{ |item|
            click_on(item)
          }
    end

    def get_section(name)
        page.all(".concept-set-group").find { |div| div.find(".concept-set-title").text == name }
    end

    def expand_section(name)
        find(".concept-set-title", :text => name, :match => :prefer_exact).click
        wait_for_overlay_to_be_hidden
    end

    def fill_chief_complaints(chief_complaints)
        wait_until {first('.leaf-observation-node', :visible => true)}
        chief_complaint_rows = page.all('.leaf-observation-node', :text => 'Chief Complaint')
        raise "There are only #{chief_complaint_rows.size} rows to fill #{chief_complaints.size} chief complaints" if chief_complaint_rows.size < chief_complaints.size
        chief_complaints.each_with_index do |chief_complaint, index|
            chief_complaint_row = chief_complaint_rows[index]
            chief_complaint_row.fill_in 'Chief Complaint', :with => chief_complaint[:name]
            chief_complaint_row.click_on 'Accept' unless chief_complaint[:coded]
            chief_complaint_row.find('.duration-value').set chief_complaint[:duration][:value]
            chief_complaint_row.find('.duration-unit').select chief_complaint[:duration][:unit]
        end
    end

    def fill_vitals_data(section, vitals)
          section.fill_in 'Pulse', :with => vitals[:pulse] if vitals.has_key? :pulse
          section.fill_in 'Diastolic', :with => vitals[:diastolic] if vitals.has_key? :diastolic
          section.fill_in 'Systolic', :with => vitals[:systolic] if vitals.has_key? :systolic
          section.click_on(vitals[:posture]) if vitals.has_key? :posture
          section.fill_in 'Temperature', :with => vitals[:temperature] if vitals.has_key? :temperature
          section.fill_in 'RR', :with => vitals[:rr] if vitals.has_key? :rr
          section.fill_in 'SPO2', :with => vitals[:spo2] if vitals.has_key? :spo2
    end
end