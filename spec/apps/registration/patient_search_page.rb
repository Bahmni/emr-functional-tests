/*
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at https://www.bahmni.org/license/mplv2hd.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */

class Registration::PatientSearchPage < Common::CommonPatientSearchPage
  #order of the element in the table
  #results_map=["ID","Name","Gender","Age","Village"]

  @isOffline = false

  def search_patient_with_id(id)
    fill_in 'registrationNumber', :with => id
    click_button_with_text 'Search'
  end

  def search_patient_with_name(name)
    fill_in 'name', :with => name
    click_button_with_text('Search',2)
    wait_for_loader_to_be_hidden
  end

  def verify_search_by_name_result(patient)
    @isOffline = patient[:isOffline]
    verify("Name",patient[:given_name])
    patient[:gender]=="Male" ? verify("Gender", "M") : verify("Gender", "F")
    verify("Age",patient[:age][:years])
    verify("ID", "Not Assigned") if @isOffline
  end

  def verify(field,expected)
    #the column position in the search result section. The position can be get during runtime. Can be done later
    results_map={"ID"=>1,"Name"=>3,"Gender"=>7,"Age"=>8,"Village"=>9}
    if @isOffline
        results_map={"ID"=>1,"Name"=>2,"Gender"=>9,"Age"=>10,"Village"=>8}
    end
    field_value=page.find(".registraition-search-results-container tbody tr td:nth-child(#{results_map[field]})").text
    expect(field_value).to include(expected)
  end
end
