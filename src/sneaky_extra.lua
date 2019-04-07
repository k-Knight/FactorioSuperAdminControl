-- =======================================================================
-- ===================== SNEAKY EXTRA REGISTRATIONS ======================
-- =======================================================================



require("./sneaky_extra_admin_tools.lua") -- [extra module]: Admin Tools
require("./sneaky_extra_player_tools.lua") -- [extra module]: Player Tools



-- function for registerig default functionality (included in gui)
SneakyExtra = {}
SneakyExtra.run_registrations = function(admin)
  SneakyExtra.register_functionality(
    "admin_tools",
    "Admin Tools",
    SneakyExtrasAdminTools.draw,
    {
      on_click = SneakyExtrasAdminTools.on_click_handler,
      on_selected = SneakyExtrasAdminTools.on_select_handler
    },
    admin
  )
  SneakyExtra.register_functionality(
    "player_tools",
    "Player Tools",
    SneakyExtrasPlayerTools.draw,
    {
      on_click = SneakyExtrasPlayerTools.on_click_handler,
      on_selected = SneakyExtrasPlayerTools.on_select_handler,
      on_checked = SneakyExtrasPlayerTools.on_checked_handler,
      on_value = SneakyExtrasPlayerTools.on_value_handler
    },
    admin
  )
end



-- =======================================================================
-- ======================== SNEAKY EXTRAS SCRIPT =========================
-- =======================================================================



SneakyExtra.on_gui_click_handler = function(event, super_index)
  local admin = SneakySuperAdminManager.get(super_index)

  if event.element.name == "sneaky_extras_btn" then
    if admin.additional_menu_opened == true then
      SneakyExtra.close_additional_menu(admin)
    else
      SneakyExtra.open_additional_menu(admin)
    end
  elseif event.element.name == "extras_close_menu" then
    SneakyExtra.close_additional_menu(admin)
  end

  local admin_gui = admin:get_gui()

  if admin_gui.center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.btn_name.internal == event.element.name then
      if admin_gui.center.extras_menu.extras_wrapper ~= nil then
        admin_gui.center.extras_menu.extras_wrapper.destroy()
      end
      admin_gui.center.extras_menu.add{type = "frame", caption = functionality.btn_name.caption, name = "extras_wrapper", direction = "vertical", style = "inside_deep_frame_for_tabs"}
      SneakyStyling.apply_simple_style(
        admin_gui.center.extras_menu.extras_wrapper,
        {
          size = {width = 772},
          padding = {horizontal = 10},
          margin = {horizontal = 5, vertical = 5},
        }
      )
      for _, btn in pairs(event.element.parent.children) do
        btn.enabled = true
      end
      event.element.enabled = false
      functionality.draw_function(admin_gui.center.extras_menu.extras_wrapper, admin)
    end
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.click_handler ~= nil then
      if not event.element.valid then
        return
      end
      functionality.click_handler(event, admin)
    end
  end
end

SneakyExtra.on_gui_checked_state_changed_handler = function(event, super_index)
  local admin = SneakySuperAdminManager.get(super_index)

  if admin:get_gui().center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.checkbox_handler ~= nil then
      if not event.element.valid then
        return
      end
      functionality.checkbox_handler(event, admin)
    end
  end
end

SneakyExtra.on_gui_selection_state_changed_handler = function(event, super_index)
  local admin = SneakySuperAdminManager.get(super_index)

  if admin:get_gui().center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.select_handler ~= nil then
      if not event.element.valid then
        return
      end
      functionality.select_handler(event, admin)
    end
  end
end

SneakyExtra.on_gui_value_changed_handler = function(event, super_index)
  local admin = SneakySuperAdminManager.get(super_index)

  if admin:get_gui().center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(admin.extras.functionality) do
    if functionality.slider_handler ~= nil then
      if not event.element.valid then
        return
      end
      functionality.slider_handler(event, admin)
    end
  end
end

SneakyExtra.add_functionality = function(name, button_caption, draw_function, handlers, admin)
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

SneakyExtra.register_functionality = function(name, button_caption, draw_function, handlers, admin)
  if global.player_name == nil then
    init_mod()
  end

  if type(button_caption) ~= "string" or type(draw_function) ~= "function" then
    return false
  end

  if admin == nil then
    local result = false
    for _, superadmin in ipairs(SneakySuperAdminManager.get_all()) do
      result = result or SneakyExtra.add_functionality(name, button_caption, draw_function, handlers, superadmin)
    end
    return result
  else
    return SneakyExtra.add_functionality(name, button_caption, draw_function, handlers, admin)
  end
end



-- =======================================================================
-- ========================= EXTRAS GUI SCRIPT ==========================
-- =======================================================================



SneakyExtra.draw_btn_gui = function(frame, superadmin)
  local extras_cation = "Open Extras"
  if superadmin.additional_menu_opened == true then
    extras_cation = "Close Extras"
  end

  frame.add{type = "button", name = "sneaky_extras_btn", caption = extras_cation, mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.sneaky_extras_btn,
    {
      size = {width = 200},
      margin = {left = 12, top = 10, bottom = 5}
    }
  )
end

SneakyExtra.open_additional_menu = function(superadmin)
  superadmin.additional_menu_opened = true
  superadmin:get_gui().top.sneaky_frame.sneaky_extras_btn.caption = "Close Extras"

  SneakyExtra.draw_menu(superadmin)
end

SneakyExtra.close_additional_menu = function(superadmin)
  superadmin.additional_menu_opened = false
  local admin_gui = superadmin:get_gui()

  admin_gui.top.sneaky_frame.sneaky_extras_btn.caption = "Open Extras"

  if admin_gui.center.extras_menu ~= nil then
    admin_gui.center.extras_menu.destroy()
  end
end

SneakyExtra.add_btn_to_panel = function(btn_name, superadmin)
  local admin_gui = superadmin:get_gui()

  admin_gui.center.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel.add{type = "button", name = btn_name.internal, caption = btn_name.caption, mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    admin_gui.center.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel[btn_name.internal],
    {
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )
end

SneakyExtra.draw_menu = function(superadmin)
  local gui_frame = superadmin:get_gui().center

  gui_frame.add{type = "frame", caption = "Extra Functionality Menu", name = "extras_menu", direction = "vertical"}
  SneakyStyling.apply_simple_style(
    gui_frame.extras_menu,
    {
      size = {width = 800},
      padding = {horizontal = 5},
      margin = {horizontal = 0},
    }
  )

  gui_frame.extras_menu.add{type = "table", name = "extra_buttons_table", column_count = 2}
  SneakyStyling.apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table,
    {
      size = {width = 782},
      padding = {horizontal = 0},
      margin = {horizontal = 0}
    }
  )

  -- empty elements of the table
  gui_frame.extras_menu.extra_buttons_table.add{type = "frame", name = "extra_buttons_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  SneakyStyling.apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame,
    {
      size = {width = 674},
      padding = 5,
      margin = { left = 3}
    }
  )
  gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame.add{type = "flow", name = "extra_buttons_panel", direction = "horizontal"}
  SneakyStyling.apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel,
    {
      size = {width = 663},
      padding = {horizontal = 0},
      margin = {horizontal = 0},
      spacing = {horizontal = 5}
    }
  )

  -- close button for the frame
  gui_frame.extras_menu.extra_buttons_table.add{type = "button", name = "extras_close_menu", caption = "Close menu", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table.extras_close_menu,
    {
      size = {width = 90},
      padding = {horizontal = 2},
      margin = {left = 10}
    }
  )

  -- add all registered buttons
  for _, functionality in pairs (superadmin.extras.functionality) do
    SneakyExtra.add_btn_to_panel(functionality.btn_name, superadmin)
  end
end