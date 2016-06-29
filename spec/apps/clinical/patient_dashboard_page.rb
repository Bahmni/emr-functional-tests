class Clinical::PatientDashboardPage < Common::DisplayControlsPage

  TREATMENT_SECTION = "#dashboard-treatments"

    def verify_current_dashboard(name)
        dashboard = find('.dashboard a', :text => name, :match => :prefer_exact).parent
        expect(dashboard).to have_selector('.tab-selected')
    end

    def add_dashboard(name)
        find('#addDashboardButton').click
        find('.unOpenedDashboard', :text => name, :match => :prefer_exact).click
        wait_for_overlay_to_be_hidden
    end

    def navigate_to_dashboard(name)
        find(".dashboard a", :text => name, :match => :prefer_exact).click
        wait_for_overlay_to_be_hidden
    end

    def verify_visit_vitals_info(vitals)
        vitals_section = find('.dashboard-section h2', :text => 'Vitals').parent
        expect(vitals_section).to have_content("BMI #{vitals[:bmi]}") if vitals.has_key? :bmi
        expect(vitals_section).to have_content("BMI STATUS #{vitals[:bmi_status]}") if vitals.has_key? :bmi_status
        expect(vitals_section).to have_content("HEIGHT #{vitals[:height]}") if vitals.has_key? :height
        expect(vitals_section).to have_content("WEIGHT #{vitals[:weight]}") if vitals.has_key? :weight
    end

    def start_consultation
        find(".grouped-buttons a", :text => 'Consultation', :match => :prefer_exact).click
    end

    def verify_existing_drugs(sections)
      sections.each do |section|
        table = page.find(TREATMENT_SECTION, :text => section['visit_date'])
        section['drugs'].each do |drug|
          expect(table).to have_content(drug)
        end
      end
    end

    def navigate_to_all_treatments_page
      find('h2', :text =>'Treatments').click
    end

    def navigate_to_visit_page(visit_date)
      find("a", :text=>visit_date, :match => :prefer_exact).click
    end

    def navigate_to_current_visit
      find("#Visits i[title='Current Visit']").click
      wait_for_overlay_to_be_hidden
    end

    def verify_new_drugs(*drugs)
      verify_drug_details(TREATMENT_SECTION, *drugs)
    end

    def verify_patient_profile_section(name)
      # todo: add more verification
      patient_section = find("#patient_information")
      expect(patient_section).to have_content(name)
    end

  def verify_radiology_section(radiology_image_concepts)
    expect(page).to have_selector('.dashboard-radiology-section .radiology-doc-item', :count=>radiology_image_concepts.length)
    radiology_image_concepts.each_with_index { |radiology_image_item, index|
      expect(find(".dashboard-radiology-section .radiology-doc-item:nth-of-type(#{index+1}) a", :visible => true).text).to eq(radiology_image_item[:concept_name])
      image_count = radiology_image_item[:image_count]
      if(image_count)
      expect(find(".dashboard-radiology-section .radiology-doc-item:nth-of-type(#{index+1}) span", :visible => true).text).to eq("(#{image_count})")
      end
    }
  end

  def verify_vitals(observations,id)
    observations_section = find('[id="'+id+'"]')
    expect(observations_section).to have_content("Pulse (72 - 72) #{observations[:pulse]} /min") if observations.has_key? :pulse
    expect(observations_section).to have_content("Diastolic (70 - 85) #{observations[:diastolic]} mm Hg") if observations.has_key? :diastolic
    expect(observations_section).to have_content("Systolic (110 - 140) #{observations[:systolic]} mm Hg") if observations.has_key? :systolic
    expect(observations_section).to have_content("Posture #{observations[:posture]}") if observations.has_key? :posture
    expect(observations_section).to have_content("Temperature (98.6 - 98.6) #{observations[:temperature]} F") if observations.has_key? :temperature
    expect(observations_section).to have_content("RR (16 - 20) #{observations[:rr]} /min") if observations.has_key? :rr
    expect(observations_section).to have_content("SPO2 (> 97) #{observations[:spo2]} %") if observations.has_key? :spo2
  end

  def verify_second_vitals(observations,id)
    verify_vitals(observations, id)
  end

  def verify_nutritional_values(observations,id)
    observations_section = find('[id="'+id+'"]')
    expect(observations_section).to have_content("BMI #{observations[:bmi]}") if observations.has_key? :bmi
    expect(observations_section).to have_content("BMI STATUS #{observations[:bmi_status]}") if observations.has_key? :bmi_status
    expect(observations_section).to have_content("HEIGHT #{observations[:height]}") if observations.has_key? :height
    expect(observations_section).to have_content("WEIGHT #{observations[:weight]}") if observations.has_key? :weight
  end

  def verify_history_and_examination_values(observations,id)
    observations_section = find('[id="'+id+'"]')
    verify_chief_complaints(observations_section, observations[:chief_complaints]) if observations.has_key? :chief_complaints
    expect(observations_section).to have_content("History Notes #{observations[:history_notes]}") if observations.has_key? :history_notes
    expect(observations_section).to have_content("Examination Notes #{observations[:examination_notes]}") if observations.has_key? :examination_notes
    expect(observations_section).to have_content("Smoking History #{observations[:smoking_history]}") if observations.has_key? :smoking_history
  end

  def verify_gynaecology_values(observations,id)
    observations_section = find('[id="'+id+'"]')
    expect(observations_section).to have_content("P/S (Per Speculum) - Cervix #{observations[:ps_perSpeculum_cervix][0]}, #{observations[:ps_perSpeculum_cervix][1]}") if observations.has_key? :ps_perSpeculum_cervix
  end

  def verify_anc_values(observations, id)
    observations_section = find('[id="'+id+'"]')
    expect(observations_section).to have_content("#{observations[:Danger_sign]}")
    expect(observations_section).to have_content("#{observations[:ANC_Visit_Number]}")
  end

  def verify_obstetrics_values(observations,id)
    observations_section = find('[id="'+id+'"]')
    expect(observations_section).to have_content("Fundal Height (Weeks) #{observations[:fundal_height]}") if observations.has_key? :fundal_height
    expect(observations_section).to have_content("P/A Presenting Part #{observations[:pa_presenting_part]}") if observations.has_key? :pa_presenting_part
    expect(observations_section).to have_content("FHS #{observations[:fhs]}") if observations.has_key? :fhs
    #expect(observations_section).to have_content("LMP #{observations[:lmp]}") if observations.has_key? :lmp
    expect(observations_section).to have_content("Amount of Liquor #{observations[:amountOfLiquor]}") if observations.has_key? :amountOfLiquor
  end

  def verify_observations_on_all_details_page(observations, id)
    observation_section = "observationControlSection"
    find('[id="'+id+'"]').find("h2").click
    verify_nutritional_values(observations, observation_section) if observations.has_key? :bmi
    verify_history_and_examination_values(observations, observation_section)  if observations.has_key? :chief_complaints
    verify_gynaecology_values(observations, observation_section)  if observations.has_key? :ps_perSpeculum_cervix
    verify_second_vitals(observations, observation_section) if observations.has_key? :pulse
    verify_vitals(observations, observation_section) if observations.has_key? :pulse
    verify_obstetrics_values(observations, observation_section) if observations.has_key? :fundal_height
    find('.ngdialog-theme-default.ng-dialog-all-details-page .ngdialog-close').click
  end

  def verify_presence_of_start_consultation_link()
    expect(page).to have_link("Consultation")
  end

  def verify_absence_of_start_consultation_link()
    dashboard_header_right_section= page.find('div.dashboard-header-right-wrapper')
    expect(dashboard_header_right_section).to have_no_link("Consultation")
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

  def verify_retrospective_date(location,retro_date)
    verify_retrospective_date_tab(location,retro_date)
    verify_retrospective_date_in_visit_section(retro_date)
  end

  def verify_retrospective_data(retro_date,vitals)
    verify_retrospective_date_in_visits_page(vitals)
    verify_retrospective_date_in_all_vitals_page(retro_date)
  end

  def verify_retrospective_date_tab(location,retro_date)
    expected=find("div.retro-date-widget-header").text
    expect(expected).to eq(location+","+retro_date)
  end

  def verify_retrospective_date_in_visit_section(retro_date)
    expected=find("#Visits").text
    expect(expected).to match(retro_date+" - "+retro_date)
  end

  def verify_retrospective_date_in_drug_section(retro_date)
    expected=find("treatment-table thead").text
    expect(expected).to match(retro_date)
  end

  def verify_retrospective_date_in_visits_page(vitals)
    click_link_with_text "Vitals"
    visit_page.verify_observations(vitals)
  end

  def verify_retrospective_date_in_all_vitals_page(retro_date)
    expected=find("#Visits").text
    expect(expected).to be(retro_date+" - "+retro_date)
  end

end