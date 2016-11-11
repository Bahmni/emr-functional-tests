class Eli::AddSamplePage < Page
  def generate_accession_number_and_save
    find(:css, '[name="generate"]').click
    page.execute_script('jQuery(savePage)')
    wait_for_overlay_to_be_hidden
  end
end
