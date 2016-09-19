class Clinical::TreatmentPage < Page
  include Clinical::ConsultationHeader

  def add_new_drug(*drugs)
    drugs.each do |drug|
      fill_drug_name(drug)
      if drug.has_key? :dose
        fill_uniform_dosing_details(drug)
      end
      if drug.has_key? :morning_dose
        fill_variable_dosing_details(drug)
      end
      click_on("SOS") if drug[:sos]
      select(drug[:instructions], :from => "instructions") if drug.has_key? :instructions
      fill_in "duration", :with => drug[:duration] if drug.has_key? :duration
      fill_in "start-date", :with => drug[:start_date] if drug.has_key? :start_date
      if drug[:quantity_units]!= 'Tablet(s)' && drug[:quantity_units] != 'Capsule(s)' && drug[:quantity_units] != 'Teaspoon'
         fill_in "quantity", :with => drug[:quantity] if drug.has_key? :quantity
      end
      fill_in "additional-instructions", :with => drug[:additional_instructions] if drug.has_key? :additional_instructions
      click_on("Add")
    end
  end

  def refill_drug(tab_name, *drugs)
    go_to_treatment_tab(tab_name)
    drugs.each do |drug|
      drug_details = create_drug_details_string_with_quantity(drug)
      tab_section = page.all(".tab").find { |div| div.find(".tab-label").text == tab_name }
      expect(tab_section).to have_content(drug_details)
      drug_section = tab_section.all("#ordered-drug-orders").find { |li| li.find(".drug-details").text == drug_details }
      drug_section.find(".refill-btn").click
    end
  end

  def verify_drug_on_new_prescription(*drugs)
    drugs.each do |drug|
      drug_details = create_drug_details_string_with_quantity(drug)
      section = page.find(".new-drug-order")
      expect(section).to have_content(drug_details)
      drug_element = section.all('#new-drug-orders').find { |li| li.find(".drug-details").text == drug_details }
      date_section = drug_element.all(".start-date").find { |div| div.text == "from " + drug[:start_date] }
      expect(date_section).to have_content("from "+drug[:start_date])
    end
  end

  def expect_popup(drug)
    section = page.find(".revise-refill-modal-wrapper")
    expect(section).to have_content(drug[:drug_name]+" from "+ drug[:start_date]+" to "+drug[:stop_date]+" is conflicting with drug order you are trying to add. You can revise or refill instead.")
  end

  def refill_conflicting_drug()
    section = page.find(".revise-refill-modal-wrapper")
    section.find("#modal-refill-button").click
  end

  def verify_drug_on_tab(tab_name, *drugs)
    go_to_treatment_tab(tab_name)
    drugs.each do |drug|
      drug_details = create_drug_details_string_with_quantity(drug)
      drug_section = page.all(".tab").find { |div| div.find(".tab-label").text == tab_name }
      expect(drug_section).to have_content(drug_details)
      expect(drug_section).to have_content(drug[:additional_instructions])
    end
  end

  def go_to_treatment_tab(tab_name)
    find('.tab-label', :text => tab_name).click
  end

  private

  def fill_drug_name(details)
    searchable_drug_name = details[:drug_name].split(" (")[0];
    fill_in "drug-name", :with => searchable_drug_name
    begin
    if details.has_key? :drug_name
    	find('.ui-menu-item').click
    end	
    rescue
    	find(:id, 'accept-button').click
    end
    
		
  end

  def fill_uniform_dosing_details(details)
    fill_in "uniform-dose", :with => details[:dose]
    select(details[:dose_unit], :from => "uniform-dose-unit") if details.has_key? :dose_unit
    select(details[:frequency], :from => "frequency") if details.has_key? :frequency
    select(details[:drug_route], :from => "route") if details.has_key? :drug_route
  end

  def fill_variable_dosing_details(details)
    # find('.exchange-btn').click if find('.variable-frequency', :visible => false)
    find('.exchange-btn').click
    fill_in "morning-dose", :with => details[:morning_dose] if details.has_key? :morning_dose
    fill_in "afternoon-dose", :with => details[:noon_dose] if details.has_key? :noon_dose
    fill_in "evening-dose", :with => details[:night_dose] if details.has_key? :night_dose
    select(details[:dose_unit], :from => "variable-dose-unit") if details.has_key? :dose_unit
  end

  def create_drug_details_string_with_quantity(drug)
    drug_details = create_drug_details_string(drug)
    drug_details.concat("\(").concat([drug[:quantity], drug[:quantity_units]].reject { |s| s.nil? || s.empty? }.join(' ')).concat("\)")
    drug_details
  end
end
