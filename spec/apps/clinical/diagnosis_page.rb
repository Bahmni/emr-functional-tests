class Clinical::DiagnosisPage < Page
  include Clinical::ConsultationHeader

  def add_diagnosis(details)
    go_to_tab("Diagnosis")
    fill_in "name-#{details[:index]}", :with => details[:name]
    page.find("#order-#{details[:index]}").all("button").find {|button| button.text == details[:order] }.click
    page.find("#certainty-#{details[:index]}").all("button").find {|button| button.text == details[:certainty] }.click
    click_on "accept-button-#{details[:index]}"
  end

end