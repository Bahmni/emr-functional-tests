class Common::DisplayControlsPage < Page

  def verify_chief_complaints(observations_section, chief_complaints)
    chief_complaints.each do |chief_complaint|
      expect(observations_section).to have_content("Chief Complaint #{chief_complaint[:name]} since #{chief_complaint[:duration][:value]} #{chief_complaint[:duration][:unit]}")
    end
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

  def verify_admission_details(patient_details)
    admission_details_section = page.find("#admissionDetails")
    expect(admission_details_section).to have_content(patient_details[:admit_details])
    expect(admission_details_section).to have_content(patient_details[:discharge_details])
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
    expect(patient_information_section).to have_content("Distance From Center (in km) #{patient_details[:distanceFromCenter]}")
    expect(patient_information_section).to have_content("Urban #{patient_details[:is_urban]}")
    expect(patient_information_section).to have_content("cluster #{patient_details[:cluster]}")
    expect(patient_information_section).to have_content("Ration Card Type #{patient_details[:ration_card]}")
    expect(patient_information_section).to have_content("Family Income (per month in Rs) #{patient_details[:family_income]}")
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

  def verify_drug_details(section, *drugs)
    table = page.find(section)
    drugs.each do |drug|
      drug_details = create_drug_details_string(drug)
      expect(table).to have_content(drug_details)
    end
  end

  def verify_radiology_orders_section(identifier, radiology_tests)
    radiology_order_notes = page.find(identifier)
    radiology_tests.each do |test|
      expect(radiology_order_notes).to have_content(test[:name])
      test[:notes].each {|note| expect(radiology_order_notes).to have_content(note)}
    end
  end

end