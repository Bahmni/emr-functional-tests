module Clinical::ControlPanel

  def open_side_panel
    find('button.toggle-patient').click
  end

  def navigate_to_home
    open_side_panel
    find(".bahmni-home a").click
    wait_for_overlay_to_be_hidden
  end

end