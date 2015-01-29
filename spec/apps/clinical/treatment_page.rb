class Clinical::TreatmentPage < Page
  include Clinical::ConsultationHeader

  def fill_new_drug(details)
    wait_for_overlay_to_be_hidden
    searchable_drug_name = details[:drug_name].split(" (")[0];
    fill_in "drug-name", :with => searchable_drug_name if details.has_key? :drug_name
    find('.ui-menu-item').click
    fill_in "uniform-dose", :with => details[:dose] if details.has_key? :dose
    select(details[:frequency], :from => "frequency") if details.has_key? :frequency
    click_on("SOS") if details[:sos]
    select(details[:instructions], :from => "instructions") if details.has_key? :instructions
    fill_in "duration", :with => details[:duration] if details.has_key? :duration
    fill_in "start-date", :with => details[:start_date] if details.has_key? :start_date
    click_on("Add")
  end

  def verify_drug_on_tab(tab_name, drug)
    drug_name = drug[:drug_name]
    drug_details = create_drug_detail(drug)
    go_to_tab(tab_name)
    drug_section = page.all(".tab").find { |div| div.find(".tab-label").text == tab_name }
    expect(drug_section).to have_content(drug_name)
    expect(drug_section).to have_content(drug_details)
  end

  def create_drug_detail(drug)
    sos = "SOS" if drug[:sos]
    drug_details = [drug[:dose], drug[:dose_unit]].reject{|s| s.nil? || s.empty?}.join(' ').concat(", ")
    drug_details.concat([drug[:frequency], drug[:instructions], sos, drug[:drug_route]].reject{|s| s.nil? || s.empty?}.join(', ')).concat(" - ")
    drug_details.concat([drug[:duration], drug[:duration_unit]].reject{|s| s.nil? || s.empty?}.join(' '))
    drug_details
  end

  private
  def go_to_tab(tab_name)
    find('.tab-label', :text => tab_name).click
  end
end