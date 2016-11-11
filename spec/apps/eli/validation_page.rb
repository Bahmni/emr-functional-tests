class Eli::ValidationPage < Page

  def accept_results_of_all_test
    #find(:css , 'input.acceptAll').check
    check('selectAllAccept')
    click_on('Save')
    wait_for_overlay_to_be_hidden
  end

  def verify_test_count(expected_count)
    actual_count = page.all(:css , 'input.accepted').size - 1
    expect(expected_count).to eq(actual_count)
  end

end
