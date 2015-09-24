class Adt::PatientDashboardPage < Common::DisplayControlsPage

  def perform_action(action_details)
    select(action_details[:action], :from => "dispositionAction")
    find("#adtNotes textArea").set(action_details[:notes]) if action_details.has_key? :notes
  end

  def perform_admit_action(action_details)
    perform_action(action_details)
    click_on "Admit"
    wait_for_overlay_to_be_hidden
    sleep(1)
  end

  def perform_cancel_action(action_details)
    perform_action(action_details)
    click_on "Cancel"
    wait_for_overlay_to_be_hidden
  end

  def perform_discharge_action(action_details)
    perform_action(action_details)
    click_on "Discharge"
    wait_for_overlay_to_be_hidden
  end

  def perform_undo_discharge_action(action_details)
    perform_action(action_details)
    click_on "Undo Discharge"
    wait_for_overlay_to_be_hidden
  end

  def perform_transfer_action(action_details)
    perform_action(action_details)
    click_on "Transfer"
    wait_for_overlay_to_be_hidden
  end

  def verify_admission_details(admit_details)
    admission_details_section= page.find('#admissionDetails').text
    expect(admission_details_section).to include(admit_details[:notes])
    expect(admission_details_section).to include(admit_details[:ward])
    expect(admission_details_section).to include(admit_details[:bed_detail])
  end
end