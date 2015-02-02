class Clinical::SummaryPag < Page

  @@treatment_section = "#treatment-summary"

  def verify_existing_drugs(sections)
    sections.each do |section|
      table = page.find(@@treatment_section, text: section['visit_date'])
      section['drugs'].each do |drug|
        expect(table).to have_content(drug)
      end
    end
  click_on "Back"
  end

  def verify_new_drugs(*drugs)
    verify_drug_details(@@treatment_section, *drugs)
  end

end