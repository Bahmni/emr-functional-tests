class Clinical::PatientDashboardPage < Page
    def verify_visit_vitals_info(vitals)
        vitals_section = find('.dashboard-section h2', :text => 'Vitals').parent
        expect(vitals_section).to have_content("BMI #{vitals[:bmi]}") if vitals.has_key? :bmi
        expect(vitals_section).to have_content("BMI STATUS #{vitals[:bmi_status]}") if vitals.has_key? :bmi_status
        expect(vitals_section).to have_content("HEIGHT #{vitals[:height]}") if vitals.has_key? :height
        expect(vitals_section).to have_content("WEIGHT #{vitals[:weight]}") if vitals.has_key? :weight
    end

    def start_consultation
        find("a.confirm", :text => 'Consultation').click
    end

    def verify_existing_drugs(sections)
      sections.each do |section|
        table = page.find('.dashboard-treatment-section ' + '.' +section['header'])
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

   def verify_drugs_all_treatments_page(sections)
     navigate_to_all_treatments_page
     sections.each do |section|
       table = page.find('table', text: section['visit_date'])
       section['drugs'].each do |drug|
         expect(table).to have_content(drug)
       end
     end
    click_on "Back"
   end

end