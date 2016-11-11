class Eli::ResultPage < Page
  def enter_results_for_all_test
    page.all(:css , '.testResultValue').each do |test|
      test.set("10")
    end

    click_on('Save')
    wait_for_overlay_to_be_hidden
  end
end
