class Clinical::ObservationsPage < Page
    include Clinical::ConsultationHeader

    def fill_history_and_examinations_section(details)
        go_to_tab ("Observations")
        wait_for_overlay_to_be_hidden
        sleep 1
        expand_section "History_and_Examination"
        fill_chief_complaints details[:chief_complaints] if details.has_key? :chief_complaints
        fill_in "History", :with => details[:history_notes] if details.has_key? :history_notes
        fill_in "Examination", :with => details[:examination_notes] if details.has_key? :examination_notes
        click_on(details[:smoking_history]) if details.has_key? :smoking_history
    end

    def add_consultation_images_in_history_and_examinations_section(image_urls)
        go_to_tab ("Observations")
        wait_for_overlay_to_be_hidden
        wait_for_element_with_xpath_to_be_visible('//*[@id="History_and_Examination"]')
        expand_section "History_and_Examination"
        wait_for_element_with_xpath_to_be_visible('//label/span[text()="Chief Complaint Notes"]')
        add_consultation_images(image_urls)
    end

    def add_consultation_images(image_urls)
        image_urls.each {|image_path|
          elements=page.all(:xpath,'//button[contains(@id,"image_addmore_observation")]')
          elements[elements.length-1].click #click the last addmore button. This is to avoid some sync issue.
          sleep 1
          index=page.all(:xpath,'//input[@name="image"]').length
          id= find(:xpath,"(//input[@name='image'])[#{index}]")[:id]
          attach_file(id, File.expand_path("#{image_path[:image]}"), :visible => true)
          sleep 1
          wait_for_overlay_to_be_hidden
          page.execute_script('window.scrollTo(0,2000)')
        }
      sleep 1

    end

    def verify_saved_images(expected_image_count)
        wait_for_element_with_xpath_to_be_visible('//strong[text()="Consultation Images"]')
        actual_image_count=page.all('div.file img').length
        expect(actual_image_count).to eq(expected_image_count)
    end

    def delete_existing_images
        page.all('div.file-remove button.row-remover').each {|element| element.click; sleep 0.5}
    end

    def undo_delete
      sleep 1
      page.all('div.file-remove button.row-remover span.fa-undo')[1].click
    end

    def fill_vitals_section(vitals)
        expand_section "Vitals"
        fill_vitals_data(get_section('Vitals'), vitals)
    end

    def fill_second_vitals_section(vitals)
        select_template "Second_Vitals"
        fill_vitals_data(get_section("Second Vitals"), vitals)
    end

    def fill_obstetrics_section(obstetrics)
        select_template "Obstetrics"
        fill_in 'Fundal Height', :with => obstetrics[:fundal_height]  if obstetrics.has_key? :fundal_height
        click_on(obstetrics[:pa_presenting_part]) if obstetrics.has_key? :pa_presenting_part
        click_on(obstetrics[:fhs]) if obstetrics.has_key? :fhs
        #fill_in 'LMP', :with => "23072014"
        fill_in 'Amount of Liquor', :with => obstetrics[:amountOfLiquor] if obstetrics.has_key? :amountOfLiquor
    end

    def fill_gynaecology_section(gynaecology)
        select_template "Gynaecology"
        gynaecology[:ps_perSpeculum_cervix].each{ |item|
            click_on(item)
          }
    end

    def get_section(name)
        page.all(".concept-set-group").find { |div| div.find(".section-label").text == name }
    end

    def expand_section(name)
        if find("div##{name} h2.section-title i.fa-caret-right").visible?
          find_by_id(name, :visible=>true).click
          wait_for_overlay_to_be_hidden
        end
    end

    def select_template(name)
        find("#template-control-panel-button").click
        find_by_id(name, :visible=>true).click
        expand_section(name)
    end

    def add_more_chief_complaint_row
      chief_complaint_row = page.all('.leaf-observation-node', :text => 'Chief Complaint')[0]
      chief_complaint_row.find('.add-more-btn').click
    end

    def fill_chief_complaints(chief_complaints)
        wait_until {first('.leaf-observation-node', :visible => true)}
        add_more_chief_complaint_row
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

    def fill_anc_data(anc_data)
      expand_section "ANC_visit_information"
      section = get_section('ANC visit information')
      section.click_on anc_data[:Danger_sign]
      section.click_on anc_data[:ANC_Visit_Number]
    end
end