class Clinical::ObservationsPage < Page
	include Clinical::ConsultationHeader

    def fill_history_and_examinations_section(details)
    	fill_chief_complaints details[:chief_complaints] if details.has_key? :chief_complaints
        fill_in "History Notes", :with => details[:history_notes] if details.has_key? :history_notes
    end

    def fill_vitals_section(vitals)
    	expand_section "Vitals"
    	fill_in 'Pulse', :with => vitals[:pulse] if vitals.has_key? :pulse
    	fill_in 'Diastolic', :with => vitals[:diastolic] if vitals.has_key? :diastolic
    	fill_in 'Systolic', :with => vitals[:systolic] if vitals.has_key? :systolic
    	fill_in 'Temperature', :with => vitals[:temperature] if vitals.has_key? :temperature
    	fill_in 'RR', :with => vitals[:rr] if vitals.has_key? :rr
    	fill_in 'SPO2', :with => vitals[:spo2] if vitals.has_key? :spo2
    end

    private
    def expand_section(name)
    	find(".concept-set-title", :text => name, :match => :prefer_exact).click
    	wait_for_overlay_to_be_hidden
    end

    def fill_chief_complaints(chief_complaints)
		chief_compaint_rows = page.all('.leaf-observation-node', :text => 'Chief Complaint')
		chief_complaints.each_with_index do |chief_complaint, index|
			chief_complaint_row = chief_compaint_rows[index]
			chief_complaint_row.fill_in 'Chief Complaint', :with => chief_complaint[:name]
			chief_complaint_row.check 'Add New' unless chief_complaint[:coded]
			chief_complaint_row.find('.duration-value').set chief_complaint[:duration][:value]
			chief_complaint_row.find('.duration-unit').select chief_complaint[:duration][:unit]
		end
    end
end