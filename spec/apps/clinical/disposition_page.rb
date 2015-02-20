class Clinical::DispositionPage < Page
  include Clinical::ConsultationHeader

  def provide_disposition(disposition_details)
    go_to_tab("Disposition")
    select(disposition_details[:disposition], :from => "dispositionAction")
    fill_in "dispositionNotes", :with => disposition_details[:notes] if disposition_details.has_key? :notes
    save
  end
end
