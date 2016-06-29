require 'offline_spec_helper'

feature "Offline" do
    scenario 'first login to sync app data' do
        offline_first_login(:location =>  "Chandaiya CC - Kaliganj (10005345)") do
          sleep 10
        end
    end


    scenario "adding patient observations offline" do
        new_patient = {:given_name => "Ram#{(0...5).map { (97 + rand(26)).chr }.join}", :family_name => 'Singh', :gender => 'Male', :age => {:years => "40"}, :address_line => 'Offline', :isOffline => true}
        anc_data = {:Danger_sign => 'Fever', :ANC_Visit_Number => 'Four or more'}

        offline_login(:Registration, :location => 'Chandaiya CC - Kaliganj (10005345)') do
            register_new_patient(:patient => new_patient, :visit_type => 'OPD')

            visit '/app/home/index.html'

            go_to_app(:Clinical, false) do

                sleep 1

                patient_search_page.search_patient_in_all_tab(new_patient[:given_name])
                patient_dashboard_page.start_consultation

                observations_page.fill_anc_data(anc_data)

                observations_page.save
                observations_page.go_to_dashboard_page

                patient_dashboard_page.verify_anc_values(anc_data, "Maternal-Health")
            end
        end
    end

    scenario 'should sync Patient clinical data without failures' do
        offline_login(:Clinical, :location => "Chandaiya CC - Kaliganj (10005345)") do
            click_on("Sync")
            sleep 10
            hasExceptions = page.first(:css, '.error-message-container')
            if(hasExceptions)
                fail "Sync Error : " + hasExceptions.text
            end
        end
    end
end