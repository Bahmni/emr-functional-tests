class Documentupload::UploadPage < Page

  def upload_image_for_concepts(image_url_and_concepts)
    image_url_and_concepts.each { |image_and_concept|
      attach_file('image-document-upload', File.expand_path("#{image_and_concept[:image]}"), :visible => true)
      fill_in "image0", :with => "#{image_and_concept[:concept_name]}", :visible => true
      find(".ui-menu-item", :visible => true).click
    }
  end

  def create_new_visit(visit_type, start_date, end_date)
    first(".icon-plus-sign", :visible => true).click
    select visit_type
    fill_in 'endDate', :with => end_date
    fill_in 'startDate', :with => start_date
  end

  def expand_current_visit
    find(".icon-star").click
  end

  def remove_nth_image_in_current_visit(imageIndex)
    find_by_id("remove-image#{imageIndex-1}", :visible => true).click
  end

  def undo_remove_nth_image_in_current_visit(imageIndex)
    remove_nth_image_in_current_visit(imageIndex)
  end

  def scan_image_for_new_visit(image_url, concept_name)
    attach_file('file-browse', File.expand_path(image_url), :visible => true)
    fill_in "image0", :with => concept_name, :visible => true
    find(".ui-menu-item", :visible => true).click
  end

  def save_changes
    find(".icon-save", :visible => true).click
  end

  def verify_images_in_order(concepts)
    concepts.each_with_index { |concept_name, index |
      input_field_name = "image#{index}"
      expect(find(:xpath, '//input[contains(@name,"'+ input_field_name+'")]', :visible => true).value).to eq(concept_name)
    }
  end
end