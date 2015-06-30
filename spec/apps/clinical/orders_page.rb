class Clinical::OrdersPage < Page
  include Clinical::ConsultationHeader

  def select_order(section, type, name)
    go_to_tab ("Orders")
    wait_for_overlay_to_be_hidden
    open_orders_section(section)
    page.find(".multi-select-lab-tests a", :text => type).click
    page.find(".orders-section-right a", :text => name).click
  end

  private

  def open_orders_section(section)
    section_header = page.find("h2", :text => section)
    expanded = section_header.find(".fa-caret-down").visible?
    if(!expanded)
      section_header.click
    end
  end
end