class Clinical::OrdersPage < Page
  include Clinical::ConsultationHeader

  def select_order(section, type, name)
    go_to_tab ("Orders")
    wait_for_overlay_to_be_hidden
    open_orders_section(section)
    page.find(".multi-select-lab-tests a", :text => type).click
    page.find(".orders-section-right a", :text => name).click
  end

  def expand_section(section)
    open_orders_section(section)
  end

  def select_or_unselect_multiple_orders(orders,selectOrUnslect)
    orders.each do |order|
      page.find(".multi-select-lab-tests a", :text => order[:category]).click
      page.find(".orderBtnContainer a", :text => order[:name]).click
      if order[:state] == "selectAndUnselect"
        sleep 0.5
        page.find(".orderBtnContainer a", :text => order[:name]).click
      end
    end
  end

  def goto_order_tab()
    go_to_tab ("Orders")
    wait_for_overlay_to_be_hidden
  end

  def navigate_to_patient_dashboard
    go_to_dashboard_page
  end

  def verify_selected_order(section, orders)

    expand_section(section)
    selected_order_section_content= page.find("#selected-orders").text
    orders.each do |order|
      if (order[:state] == 'select' || order[:state] == 'undo_delete')
        expect(selected_order_section_content).to include(order[:name])
      else
        expect(selected_order_section_content).not_to include(order[:name])
      end
    end
  end


  def delete_or_undo_delete_order(orders,deleteOrUnDelete)
    orders.each do |order|
      if order[:state] == deleteOrUnDelete
        page.all("ul.selected-items li").each do |item|
          if item.text == order[:name]
            item.all("i")[1].click
            break
          end
        end
        sleep 0.2
      end
    end
  end



  private

  def open_orders_section(section)
    section_header = page.find("h2", :text => section, :visible=>true)
    expanded = section_header.find(".fa-caret-down").visible?
    if(!expanded)
      section_header.click
    end
  end
end