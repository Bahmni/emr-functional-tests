class Clinical::DiagnosisPage < Page
  include Clinical::ConsultationHeader

  def add_non_coded_diagnosis(details)
    go_to_tab("Diagnosis")
    fill_in "name-#{details[:index]}", :with => details[:name]
    order_button(details[:index], details[:order]).click
    certainty_button(details[:index], details[:certainty]).click
    click_on "accept-button-#{details[:index]}"
  end

  def add_coded_diagnosis(details)
    go_to_tab("Diagnosis")
    fill_in "name-#{details[:index]}", :with => details[:name]
    find("a", :text => details[:name], :match => :prefer_exact).click
    order_button(details[:index], details[:order]).click
    certainty_button(details[:index], details[:certainty]).click
  end

  def edit_past_diagnosis(details)
    go_to_tab("Diagnosis")
    history_diagnosis = page.find("div > .history-diagnosis")
    history_diagnosis.first(".diagnosis .view-past .diagnosis-name span", :text => details[:name]).click
    history_diagnosis.first(".edit-diagnosis button", :text => details[:status], :visible => true).click if details[:status]
  end

  def verify_current_diagnosis(diagnoses)
    diagnoses.each do |diagnosis|
      diagnosis_rows = page.find(".current-diagnosis").all(".diagnosis-row")
      matching_diagnosis_row = diagnosis_rows.find { |row| row.all('span', :text => diagnosis[:name]).count > 0 }
      expect(matching_diagnosis_row).to have_content(diagnosis[:certainty])
      expect(matching_diagnosis_row).to have_content(diagnosis[:order])
      expect(matching_diagnosis_row).to have_content(diagnosis[:status])
    end
  end

  def certainty_button(index, certainty)
    page.find("#certainty-#{index}").all("button").find { |button| button.text == certainty }
  end

  def order_button(index, diagnosis_order)
    page.find("#order-#{index}").all("button").find { |button| button.text == diagnosis_order }
  end

  def delete_diagnosis(details)
    go_to_tab("Diagnosis")
    numberOfDiagnosesBeforeDelete = number_of_diagnoses
    diagnosis_rows = page.find(".current-diagnosis").all(".diagnosis-row")
    matching_diagnosis_row = diagnosis_rows.find { |row| row.all('span', :text => details[:name]).count > 0 }
    matching_diagnosis_row.find(".remove-diagnosis").click

    deleteConfirmMsg = page.accept_alert
    expect(deleteConfirmMsg).to eq('Are you sure you want to remove this diagnosis?')

    wait_for_overlay_to_be_hidden
    numberOfDiagnosesAfterDelete = number_of_diagnoses

    expect(numberOfDiagnosesAfterDelete).to eq(numberOfDiagnosesBeforeDelete -1)
  end

  def number_of_diagnoses
    page.all(".diagnosis-row").count
  end

end