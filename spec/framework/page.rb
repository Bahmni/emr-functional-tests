class Page
  include Capybara::DSL
  include RSpec::Matchers
  include CapybaraDslExtensions

  def self.set_url(url)
    @@url = url
  end

  def open
    visit @@url
    self
  end

  def should_be_current_page
    url_template = Addressable::Template.new(@@url + '{?query_params*}')
    wait_until { !url_template.match(current_path_with_fragment).nil? }
  end

  def wait_for_overlay_to_be_hidden
    wait_until { !page.find('#overlay').visible? }
  end

  def wait_for_autocomplete_to_be_populated
    wait_until {page.find('.ui-autocomplete', :visible => true ) }
  end

  def verify_drug_details(section, *drugs)
    table = page.find(section)
    drugs.each do |drug|
      drug_details = create_drug_details_string(drug)
      expect(table).to have_content(drug_details)
    end
  end

  def create_drug_details_string(drug)
    sos = "SOS" if drug[:sos]
    dose = drug[:dose] if drug.has_key? :dose
  else
    if drug.has_key? :morning_dose
      dose = [drug[:morning_dose], drug[:noon_dose], drug[:night_dose]].join('-')
    end
    drug_details = [dose, drug[:dose_unit]].reject { |s| s.nil? || s.empty? }.join(' ').concat(", ")
    drug_details.concat([drug[:frequency], drug[:instructions], sos, drug[:drug_route]].reject { |s| s.nil? || s.empty? }.join(', ')).concat(" - ")
    drug_details.concat([drug[:duration], drug[:duration_unit]].reject { |s| s.nil? || s.empty? }.join(' '))
    drug_details = [drug[:drug_name], drug_details].reject { |s| s.nil? || s.empty? }.join(' ')
    drug_details
  end

  def find_section(name)
    find('.dashboard-section h2', :text => name).parent
  end

  def verify_disposition_details(disposition_details)
    disposition_section = page.find('#disposition')
    expect(disposition_section).to have_content(disposition_details[:disposition])
    expect(disposition_section).to have_content(disposition_details[:notes])
  end

  def verify_absence_of_disposition_details(disposition_details)
    disposition_section = page.find('#disposition')
    expect(disposition_section).to have_no_content(disposition_details[:disposition])
    expect(disposition_section).to have_content("No dispositions available.")
  end

  def verify_patient_profile_information(patient_details)
    patient_information_section = page.find("#patient_information")
    expect(patient_information_section.find(".patient-name")).to have_content((patient_details[:given_name] + " " + patient_details[:family_name]))
    expect(patient_information_section.find(".patient-gender-age")).to have_content(patient_details[:gender])
    expect(patient_information_section.find(".patient-gender-age")).to have_content(patient_details[:age][:years])
    expect(patient_information_section.find(".patient-address")).to have_content(patient_details[:address])
    expect(patient_information_section).to have_content("Caste #{patient_details[:caste]}")
    expect(patient_information_section).to have_content("Class #{patient_details[:class]}")
    expect(patient_information_section).to have_content("Education Details #{patient_details[:education_details]}")
    expect(patient_information_section).to have_content("Occupation #{patient_details[:occupation]}")
    expect(patient_information_section).to have_content("debt (in Rs) #{patient_details[:debt]}")
    expect(patient_information_section).to have_content("distanceFromCenter (in km) #{patient_details[:distanceFromCenter]}")
    expect(patient_information_section).to have_content("isUrban #{patient_details[:is_urban]}")
    expect(patient_information_section).to have_content("cluster #{patient_details[:cluster]}")
    expect(patient_information_section).to have_content("RationCard #{patient_details[:ration_card]}")
    expect(patient_information_section).to have_content("Family Income (per month in Rs) #{patient_details[:family_income]}")
  end

  def verify_admission_details(patient_details)
    admission_details_section = page.find("#admissionDetails")
    expect(admission_details_section).to have_content(patient_details[:admit_details])
    expect(admission_details_section).to have_content(patient_details[:discharge_details])
  end

  def verify_diagnosis_details(diagnosis_details)
    diagnosis_details_section = page.find("#diagnosisSection")
    diagnosis_details.each_with_index { |diagnosis, index|
      expect(diagnosis_details_section.all("#diagnosisName")[index]).to have_content(diagnosis[:freeTextAnswer])
      expect(diagnosis_details_section.all("#order")[index]).to have_content(diagnosis[:order])
      expect(diagnosis_details_section.all("#certainty")[index]).to have_content(diagnosis[:certainty])
      expect(diagnosis_details_section.all("#diagnosisComments")[index]).to have_content(diagnosis[:comments])
      expect(diagnosis_details_section.all("#diagnosisDate")[index]).to have_content(diagnosis[:diagnosisDate])
      expect(diagnosis_details_section.all("#status")[index]).to have_content(diagnosis[:status])
    }
  end

  def verify_presence_of_start_consultation_link()
      expect(page).to have_link("Consultation")
  end

  def verify_absence_of_start_consultation_link()
    expect(page).to have_no_link("Consultation")
  end

  def verify_presence_of_current_visit()
      expect(page).to have_selector("i#currentVisitIcon")
  end

  def verify_absence_of_current_visit()
    expect(page).to have_no_selector("i#currentVisitIcon")
  end

  def verify_visit_type(visit_type)
    visits_section = page.find("#visitDisplayTable").first("tr#eachVisit")
    expect(visits_section.first("td#visitType")).to have_content(visit_type)
  end
end