class Order::OrderFulfilmentPage < Page

  def search_and_open_patient_orders(patient_name)
    fill_in("patientIdentifier", :with => patient_name)
    page.all("td")[2].find("a").click #click on the FIRST ROW patient id hyperlink
  end

  def fill_radiology_notes(section_name, notes)
    open_order_fulfillment_section(section_name)
    find_notes_textarea(section_name).set(notes)
  end

  def save
    click_on "Save"
    wait_for_overlay_to_be_hidden
    self
  end

  def verify_radiology_notes_history(section_name, history_note)
    open_order_fulfillment_section(section_name)
    section_header = page.find('h2', :text => section_name)
    section = section_header.find(:xpath, '../..')
    section_history = section.find('.dashboard-section')
    expect(section_history).to have_content(history_note)
  end

  private

  def open_order_fulfillment_section(section_name)
    section_header = page.find('h2', :text => section_name)
    expanded = section_header.find('.fa-caret-down').visible?
    if(!expanded)
      section_header.click
    end
  end

  def find_notes_textarea(section_name)
    section_header = page.find('h2', :text => section_name)
    section = section_header.find(:xpath, '../..')
    section.find('textarea', :match => :first)
  end
end