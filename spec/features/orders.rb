require 'spec_helper'

feature 'Orders' do
  scenario 'Add and fulfill radiology order' do
    patient = 'Test Radiology'
    radiology_tests = [
        {:name => 'Chest, 1 view', :notes => ['Hairline fracture spotted']},
        {:name => 'Ribs - Right, 2 views', :notes => ['One right rib missing', 'Not the right one, but the left rib missing']}
    ]

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.start_consultation
      orders_page.select_order('Radiology', 'chest', 'chest, 1 view')
      orders_page.select_order('Radiology', 'ribs', 'ribs - right, 2 views')
      orders_page.save
    end

    log_in_to_app(:Orders, :location => 'OPD-1') do
      order_fulfilment_page.search_and_open_patient_orders(patient)
      order_fulfilment_page.fill_radiology_notes('Chest, 1 view', 'Hairline fracture spotted')
      order_fulfilment_page.fill_radiology_notes('Ribs - Right, 2 views', 'One right rib missing')
      order_fulfilment_page.save
    end

    log_in_as_different_user(:Orders) do
      order_fulfilment_page.search_and_open_patient_orders(patient)
      order_fulfilment_page.fill_radiology_notes('Ribs - Right, 2 views', 'Not the right one, but the left rib missing')
      order_fulfilment_page.save

      order_fulfilment_page.verify_radiology_notes_history('Chest, 1 view', 'Hairline fracture spotted')
      order_fulfilment_page.verify_radiology_notes_history('Ribs - Right, 2 views', 'One right rib missing')
      order_fulfilment_page.verify_radiology_notes_history('Ribs - Right, 2 views', 'Not the right one, but the left rib missing')
    end

    log_in_to_app(:Clinical, {:location => 'OPD-1'}) do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_radiology_orders_section('#Radiology-Orders', radiology_tests)
      patient_dashboard_page.navigate_to_current_visit
      visit_page.add_tab('Orders')
      visit_page.verify_radiology_orders_section('.order', radiology_tests)
    end
  end

  scenario 'Select, Unselect and delete Orders' do

    name = Utils.generate_random_string(6)
    new_patient = {:given_name => "Ram#{name}", :family_name => 'Singh', :gender => 'Male', :age => {:years => 40}, :village => 'Ganiyari'}
    visit_info = {:fee => 15, :weight => 70, :height => 170, :comments => 'Billed'}
    patient = new_patient[:given_name]


    log_in_to_app(:Registration, :location => 'Registration') do
      register_new_patient_and_start_visit(:patient => new_patient, :visit_type => 'OPD')
      visit_page.should_be_current_page
      visit_page.save_new_patient_visit(visit_info)
    end

    radiology_orders=[{:category => 'chest',:name=>'chest, 1 view (x-ray)',:state=> 'select' },
                      {:category => 'neck',:name=>'neck soft tissue (x-ray)' ,:state=> 'select'},
                      {:category => 'head',:name=>'head skull lateral',:state=> 'select' },
                      {:category => 'face',:name=>'temporomandibular joint, bilateral (xray)',:state=> 'selectAndUnselect' },
    ]
    radiology_orders_2=[{:category => 'shoulder',:name=>'acromioclavicular joints - bilateral (x-ray)',:state=> 'select'}]

    radiology_orders_expected=[{:name=>'Acromioclavicular joints - Bilateral (X-ray)',:notes =>['']},
                               {:name=>'Chest, 1 view (X-ray)',:notes =>['']},
                               {:name=>'Neck soft tissue (X-ray)',:notes =>['']}
    ]

    radiology_orders_not_expected=[{:name=>'Acromioclavicular joints - Bilateral (X-ray)',:notes =>['']}]

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.start_consultation
      orders_page.goto_order_tab
      orders_page.expand_section('Radiology')

      orders_page.select_or_unselect_multiple_orders(radiology_orders,'select')
      orders_page.save
      orders_page.verify_selected_order('Radiology',radiology_orders)

      radiology_orders[1][:state]="delete"
      radiology_orders[2][:state]="delete"
      orders_page.delete_or_undo_delete_order(radiology_orders,'delete')

      radiology_orders[1][:state]="undo_delete"
      orders_page.delete_or_undo_delete_order(radiology_orders,'undo_delete')
      orders_page.select_or_unselect_multiple_orders(radiology_orders_2,'select')
      orders_page.save
      orders_page.verify_selected_order('Radiology',radiology_orders)
      orders_page.verify_selected_order('Radiology',radiology_orders_2)

      orders_page.navigate_to_patient_dashboard
      patient_dashboard_page.verify_radiology_orders_section('#Pacs', radiology_orders_expected)

      patient_dashboard_page.navigate_to_current_visit
      visit_page.add_tab('Orders')
      visit_page.verify_radiology_orders_section('.order', radiology_orders_expected)


    end 

    log_in_to_app(:Orders, :location => 'OPD-1') do
      order_fulfilment_page.search_and_open_patient_orders(patient)
      order_fulfilment_page.fill_radiology_notes('Acromioclavicular joints - Bilateral (X-ray)', 'Hairline fracture spotted')
      order_fulfilment_page.save
    end

    log_in_to_app(:Clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.start_consultation
      orders_page.goto_order_tab
      orders_page.expand_section('Radiology')
      radiology_orders_2[0][:state]='delete'
      orders_page.delete_or_undo_delete_order(radiology_orders_2,'delete')
      orders_page.save
      orders_page.verify_selected_order('Radiology',radiology_orders_2)

      orders_page.navigate_to_patient_dashboard
      patient_dashboard_page.verify_radiology_orders_section_not_have_deleted_order('#Radiology-Orders', radiology_orders_not_expected)

      patient_dashboard_page.navigate_to_current_visit
      visit_page.add_tab('Orders')
      visit_page.verify_radiology_orders_section_not_have_deleted_order('.order', radiology_orders_not_expected)
    end

    log_in_to_app(:Orders, :location => 'OPD-1') do
      order_fulfilment_page.search_and_open_patient_orders(patient)
      order_fulfilment_page.verify_radiology_orders_section_not_have_deleted_order('Acromioclavicular joints - Bilateral (X-ray)')
    end

  end
end