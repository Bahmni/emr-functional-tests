class Adt::PatientDashboardPage < Common::DisplayControlsPage

  def perform_action(action_details,action)
    select(action_details[:action], :from => "dispositionAction")
    find("#adtNotes textArea").set(action_details[:notes]) if action_details.has_key? :notes
    sleep 0.2
    click_on action
    wait_for_overlay_to_be_hidden
  end

  def perform_admit_action(action_details)
    perform_action(action_details,"Admit")
    sleep(1)
  end

  def perform_cancel_action(action_details)
    perform_action(action_details,"Cancel")
  end

  def perform_discharge_action(action_details)
    perform_action(action_details,"Discharge")
  end

  def perform_undo_discharge_action(action_details)
    perform_action(action_details,"Undo Discharge")
  end

  def perform_transfer_action(action_details)
    perform_action(action_details,"Save")
  end

  def verify_adt_admission_details(admit_details)
    admission_details_section= page.find('#admissionDetails').text
    expect(admission_details_section).to include(admit_details[:notes])
    expect(admission_details_section).to include(admit_details[:ward])
    expect(admission_details_section).to include(admit_details[:bed_detail])
  end

  def verify_only_undoDischarge_option_available
    expect(page).to have_select('dispositionAction', :selected => 'Undo Discharge')
    expect(page).to have_select('dispositionAction', :options => ['Select','Undo Discharge'])
  end

  def verify_only_admit_option_is_available
    expect(page).to have_select('dispositionAction', :options => ['Select','Admit Patient'])
  end
end