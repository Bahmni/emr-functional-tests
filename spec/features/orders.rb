require 'spec_helper'

feature 'Orders' do
  scenario 'Add and fulfill radiology order' do
    patient = 'Test Radiology'
    radiology_tests = [
        {:name => 'Chest, 1 view', :notes => ['Hairline fracture spotted']},
        {:name => 'Ribs - Right, 2 views', :notes => ['One right rib missing', 'Not the right one, but the left rib missing']}
    ]

    log_in_to_app(:clinical, :location => 'OPD-1') do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.start_consultation
      orders_page.select_order('Radiology', 'chest', 'chest, 1 view')
      orders_page.select_order('Radiology', 'ribs', 'ribs - right, 2 views')
      orders_page.save
    end

    log_in_to_app(:orders, :location => 'OPD-1') do
      order_fulfilment_page.search_and_open_patient_orders(patient)
      order_fulfilment_page.fill_radiology_notes('Chest, 1 view', 'Hairline fracture spotted')
      order_fulfilment_page.fill_radiology_notes('Ribs - Right, 2 views', 'One right rib missing')
      order_fulfilment_page.save
    end

    log_in_as_different_user(:orders) do
      order_fulfilment_page.search_and_open_patient_orders(patient)
      order_fulfilment_page.fill_radiology_notes('Ribs - Right, 2 views', 'Not the right one, but the left rib missing')
      order_fulfilment_page.save

      order_fulfilment_page.verify_radiology_notes_history('Chest, 1 view', 'Hairline fracture spotted')
      order_fulfilment_page.verify_radiology_notes_history('Ribs - Right, 2 views', 'One right rib missing')
      order_fulfilment_page.verify_radiology_notes_history('Ribs - Right, 2 views', 'Not the right one, but the left rib missing')
    end

    log_in_to_app(:clinical, {:location => 'OPD-1'}) do
      patient_search_page.view_patient_from_all_tab(patient)
      patient_dashboard_page.verify_radiology_orders_section('#Radiology-Orders', radiology_tests)
      patient_dashboard_page.navigate_to_current_visit
      visit_page.add_tab('Orders')
      visit_page.verify_radiology_orders_section('.order', radiology_tests)
    end
  end
end