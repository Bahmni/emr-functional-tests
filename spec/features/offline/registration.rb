require 'offline_spec_helper'

feature 'Offline' do
  scenario 'first login to sync app data' do
    offline_first_login(:location =>  "Chandaiya CC - Kaliganj (10005345)") do
      sleep 10
    end
  end

  scenario 'create, edit and search a patient in local database' do
    new_patient = {:given_name => "Ram#{(0...5).map { (97 + rand(26)).chr }.join}", :family_name => 'Singh', :gender => 'Male', :age => {:years => "40"}, :address_line => 'Offline', :isOffline => true}
    offline_login(:Registration, :location => "Chandaiya CC - Kaliganj (10005345)") do
      register_new_patient(:patient => new_patient)
      goto_search_page
      verify_search_by_name_results(new_patient)

      verify_details_after_update_age(20)
      new_patient[:age] = {:years => "20"}

      goto_search_page
      verify_search_by_name_results(new_patient)
    end
  end

  scenario 'should sync Patient data without failures' do
    offline_login(:Registration, :location => "Chandaiya CC - Kaliganj (10005345)") do
      click_on("Sync")
      sleep 5
      hasExceptions = page.first(:css, '.error-message-container')
      if(hasExceptions)
        fail "Sync failure"
      end
    end
  end

end