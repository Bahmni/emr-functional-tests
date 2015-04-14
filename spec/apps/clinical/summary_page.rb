class Clinical::SummaryPage < Page

  TREATMENT_SECTION = "#treatment-summary"

  def verify_existing_drugs(sections)
    sections.each do |section|
      table = page.find(TREATMENT_SECTION, text: section['visit_date'])
      section['drugs'].each do |drug|
        expect(table).to have_content(drug)
      end
    end
    find('.back-btn .icon-circle-arrow-left').click
  # click_on "Back"
  end

  def verify_new_drugs(*drugs)
    verify_drug_details(TREATMENT_SECTION, *drugs)
  end

end