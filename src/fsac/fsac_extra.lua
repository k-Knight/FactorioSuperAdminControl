-- =======================================================================
-- ====================== FSAC EXTRA REGISTRATIONS ======================
-- =======================================================================



FSACExtra = {}
FSACExtra.run_registrations = function(admin)
  KMinimalistStyling.define_style(
    "fsac_extra_flow",
    { horizontal_margin = 5, top_margin = 5, horizontal_spacing = 8, vertical_align = "center" }
  )
  KMinimalistStyling.define_style(
    "fsac_extra_btn",
    { width_f = 135, horizontal_padding = 2, horizontal_margin = 0 }
  )
  KMinimalistStyling.define_style(
    "fsac_extra_label",
    { padding = 0, margin = 0 }
  )
  KMinimalistStyling.define_style(
    "fsac_extra_drdwn",
    { width_f = 200 }
  )
end



-- =======================================================================
-- ========================== FSAC EXTRAS SCRIPT =========================
-- =======================================================================



FSACExtra.static_register = function(name, button_caption, draw_function, handlers)
  local func_ref = FSACExtra.run_registrations

  FSACExtra.run_registrations = function(admin)
    func_ref(admin)
    FSACExtra.register_functionality(name, button_caption, draw_function, handlers, admin)
  end
end

FSACExtra.on_gui_click_handler = function(event, super_index)
  local admin = FSACSuperAdminManager.get(super_index)

  if event.element.name == "fsac_extras_btn" then
    if admin.additional_menu_opened == true then
      FSACExtra.close_additional_menu(admin)
    else
      FSACExtra.open_additional_menu(admin)
    end
  elseif event.element.name == "extras_close_menu" then
    FSACExtra.close_additional_menu(admin)
  end

  local admin_gui = admin:get_gui()

  if admin_gui.center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.btn_name.internal == event.element.name then
      admin_gui.center.extras_menu.extras_wrapper.destroy()
      admin_gui.center.extras_menu.add{type = "frame", caption = functionality.btn_name.caption, name = "extras_wrapper", direction = "vertical", style = "inside_deep_frame_for_tabs"}
      KMinimalistStyling.apply_style(
        admin_gui.center.extras_menu.extras_wrapper,
        {width_f = 772, horizontal_padding = 10, margin = 5}
      )
      for _, btn in pairs(KMinimalistSafeApiObject.get_unsafe_obj(event.element.parent.children)) do
        if btn.valid ~= false then
          btn.enabled = true
        end
      end
      event.element.enabled = false
      functionality.draw_function(admin_gui.center.extras_menu.extras_wrapper, admin)
    end
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.click_handler ~= nil then
      functionality.click_handler(event, admin)
    end
  end
end

FSACExtra.on_gui_checked_state_changed_handler = function(event, super_index)
  local admin = FSACSuperAdminManager.get(super_index)

  if admin:get_gui().center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.checkbox_handler ~= nil then
      functionality.checkbox_handler(event, admin)
    end
  end
end

FSACExtra.on_gui_selection_state_changed_handler = function(event, super_index)
  local admin = FSACSuperAdminManager.get(super_index)

  if admin:get_gui().center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.select_handler ~= nil then
      functionality.select_handler(event, admin)
    end
  end
end

FSACExtra.on_gui_value_changed_handler = function(event, super_index)
  local admin = FSACSuperAdminManager.get(super_index)

  if admin:get_gui().center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.slider_handler ~= nil then
      functionality.slider_handler(event, admin)
    end
  end
end

FSACExtra.add_functionality = function(name, button_caption, draw_function, handlers, admin)
  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.name == name then
      return false
    end
  end

  admin.extras.functionality[#admin.extras.functionality + 1] = {}

  local internal_btn_name = "extras_btn_" .. name
  local functionality = admin.extras.functionality[#admin.extras.functionality]
  functionality.name = name
  functionality.btn_name = {internal = internal_btn_name, caption = button_caption}
  functionality.draw_function = draw_function

  if handlers ~= nil then
    if type(handlers.on_click) == "function" then
      functionality.click_handler = handlers.on_click
    end
    if type(handlers.on_checked) == "function" then
      functionality.checkbox_handler = handlers.on_checked
    end
    if type(handlers.on_selected) == "function" then
      functionality.select_handler = handlers.on_selected
    end
    if type(handlers.on_value) == "function" then
      functionality.slider_handler = handlers.on_value
    end
  end

  return true
end

FSACExtra.register_functionality = function(name, button_caption, draw_function, handlers, admin)
  if global.player_name == nil then
    init_mod()
  end

  if type(button_caption) ~= "string" or type(draw_function) ~= "function" then
    return false
  end

  if admin == nil then
    local result = false
    for _, superadmin in ipairs(FSACSuperAdminManager.get_all()) do
      result = result or FSACExtra.add_functionality(name, button_caption, draw_function, handlers, superadmin)
    end
    return result
  else
    return FSACExtra.add_functionality(name, button_caption, draw_function, handlers, admin)
  end
end



-- =======================================================================
-- ========================== EXTRAS GUI SCRIPT ==========================
-- =======================================================================



FSACExtra.get_wrapper_frame = function(superadmin)
  return superadmin:get_gui().center.extras_menu.extras_wrapper
end

FSACExtra.draw_btn_gui = function(frame, superadmin)
  frame.fsac_extras_btn.destroy()

  local extras_cation = "Open Extras"
  if superadmin.additional_menu_opened == true then
    extras_cation = "Close Extras"
  end

  frame.add{type = "button", name = "fsac_extras_btn", caption = extras_cation, mouse_button_filter = {"left"}}
  if superadmin.additional_menu_opened == true then
    KMinimalistStyling.apply_style(frame.fsac_extras_btn, "red_button")
  end
  KMinimalistStyling.apply_style(
    frame.fsac_extras_btn,
    {width_f = 200, left_margin = 12, top_margin = 10, bottom_margin = 5}
  )
end

FSACExtra.open_additional_menu = function(superadmin)
  superadmin.additional_menu_opened = true
  FSACExtra.draw_btn_gui(superadmin:get_gui().top.fsac_frame, superadmin);

  FSACExtra.draw_menu(superadmin)
end

FSACExtra.close_additional_menu = function(superadmin)
  superadmin.additional_menu_opened = false
  local admin_gui = superadmin:get_gui()

  FSACExtra.draw_btn_gui(admin_gui.top.fsac_frame, superadmin);
  admin_gui.center.extras_menu.destroy()
end

FSACExtra.add_btn_to_panel = function(btn_name, superadmin)
  local admin_gui = superadmin:get_gui()

  admin_gui.center.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel.add{type = "button", name = btn_name.internal, caption = btn_name.caption, mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(
    admin_gui.center.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel[btn_name.internal],
    {horizontal_padding = 2, horizontal_margin = 0}
  )
end

FSACExtra.draw_menu = function(superadmin)
  local gui_frame = superadmin:get_gui().center

  gui_frame.add{type = "frame", caption = "Extra Functionality Menu", name = "extras_menu", direction = "vertical"}
  KMinimalistStyling.apply_style(
    gui_frame.extras_menu,
    {width_f = 800, horizontal_padding = 5, horizontal_margin = 0}
  )

  gui_frame.extras_menu.add{type = "table", name = "extra_buttons_table", column_count = 2}
  KMinimalistStyling.apply_style(
    gui_frame.extras_menu.extra_buttons_table,
    {width_f = 782, horizontal_padding = 0, horizontal_margin = 0}
  )

  -- empty elements of the table
  gui_frame.extras_menu.extra_buttons_table.add{type = "frame", name = "extra_buttons_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  KMinimalistStyling.apply_style(
    gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame,
    {width_f = 674, padding = 5, left_margin = 3}
  )
  gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame.add{type = "flow", name = "extra_buttons_panel", direction = "horizontal"}
  KMinimalistStyling.apply_style(
    gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel,
    {width_f = 663, horizontal_padding = 0, horizontal_margin = 0, horizontal_spacing = 5}
  )

  -- close button for the frame
  gui_frame.extras_menu.extra_buttons_table.add{type = "button", name = "extras_close_menu", caption = "Close menu", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(
    gui_frame.extras_menu.extra_buttons_table.extras_close_menu,
    "red_button",
    {width_f = 90, horizontal_padding = 2, left_margin = 10}
  )

  -- add all registered buttons
  for _, functionality in pairs (superadmin.extras.functionality) do
    FSACExtra.add_btn_to_panel(functionality.btn_name, superadmin)
  end
end