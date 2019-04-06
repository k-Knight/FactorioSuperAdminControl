-- =======================================================================
-- ===================== SNEAKY EXTRA REGISTRATIONS ======================
-- =======================================================================



require("./sneaky_extra_admin_tools.lua") -- [extra module]: Admin Tools
require("./sneaky_extra_player_tools.lua") -- [extra module]: Player Tools



-- function for registerig default functionality (included in gui)
function run_registrations()
  register_extra_functionality(
    "admin_tools",
    "Admin Tools",
    extras_admin_tools_draw,
    {
      on_click = extras_admin_tools_on_click_handler,
      on_selected = extras_admin_tools_on_select_handler
    }
  )
  register_extra_functionality(
    "player_tools",
    "Player Tools",
    extras_player_tools_draw,
    {
      on_click = extras_player_tools_on_click_handler,
      on_selected = extras_player_tools_on_select_handler,
      on_checked = extras_player_tools_on_checked_handler,
      on_value = extras_player_tools_on_value_handler
    }
  )
end



-- =======================================================================
-- ======================== SNEAKY EXTRAS SCRIPT =========================
-- =======================================================================



function extras_on_gui_click_handler(event)
  if event.element.name == "sneaky_extras_btn" then
    if global.additional_menu_opened == true then
      close_additional_menu()
    else
      open_additional_menu()
    end
  elseif event.element.name == "extras_close_menu" then
    close_additional_menu()
  end

  if game.players[global.player_name].gui.center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(global.extras.functionality) do
    if functionality.btn_name.internal == event.element.name then
      if game.players[global.player_name].gui.center.extras_menu.extras_wrapper ~= nil then
        game.players[global.player_name].gui.center.extras_menu.extras_wrapper.destroy()
      end
      game.players[global.player_name].gui.center.extras_menu.add{type = "frame", caption = functionality.btn_name.caption, name = "extras_wrapper", direction = "vertical", style = "inside_deep_frame_for_tabs"}
      apply_simple_style(
        game.players[global.player_name].gui.center.extras_menu.extras_wrapper,
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
      functionality.draw_function(game.players[global.player_name].gui.center.extras_menu.extras_wrapper)
    end
  end

  for _, functionality in pairs(global.extras.functionality) do
    if functionality.click_handler ~= nil then
      functionality.click_handler(event)
    end
  end
end

function extras_on_gui_checked_state_changed_handler(event)
  if game.players[global.player_name].gui.center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(global.extras.functionality) do
    if functionality.checkbox_handler ~= nil then
      functionality.checkbox_handler(event)
    end
  end
end

function extras_on_gui_selection_state_changed_handler(event)
  if game.players[global.player_name].gui.center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(global.extras.functionality) do
    if functionality.select_handler ~= nil then
      functionality.select_handler(event)
    end
  end
end

function extras_on_gui_value_changed_handler(event)
  if game.players[global.player_name].gui.center.extras_menu == nil then
    return
  end

  for _, functionality in pairs(global.extras.functionality) do
    if functionality.slider_handler ~= nil then
      functionality.slider_handler(event)
    end
  end
end

function register_extra_functionality(name, button_caption, draw_function, handlers)
  if global.player_name == nil then
    init_mod()
  end

  if type(button_caption) ~= "string" or type(draw_function) ~= "function" then
    game.players[global.player_name].print("[SILENT]: failed to register extra functionality")
    return false
  end

  if global.extras == nil or global.extras.functionality == nil then
    init_mod()
  end
  for _, functionality in pairs(global.extras.functionality) do
    if functionality.name == name then
      return false
    end
  end

  global.extras.functionality[#global.extras.functionality + 1] = {}

  local internal_btn_name = "extras_btn_" .. name
  local functionality = global.extras.functionality[#global.extras.functionality]
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

function add_extra_btn_to_panel(btn_name)
  game.players[global.player_name].gui.center.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel.add{type = "button", name = btn_name.internal, caption = btn_name.caption, mouse_button_filter = {"left"}}
  apply_simple_style(
    game.players[global.player_name].gui.center.extras_menu.extra_buttons_table.extra_buttons_frame.extra_buttons_panel[btn_name.internal],
    {
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )
end



-- =======================================================================
-- ========================= EXTRAS GUI SCRIPT ==========================
-- =======================================================================

function draw_extras_btn_gui(frame)
  local extras_cation = "Open Extras"
  if global.additional_menu_opened == true then
    extras_cation = "Close Extras"
  end

  frame.add{type = "button", name = "sneaky_extras_btn", caption = extras_cation, mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.sneaky_extras_btn,
    {
      size = {width = 200},
      margin = {left = 12, top = 10, bottom = 5}
    }
  )
end

function open_additional_menu()
  global.additional_menu_opened = true
  game.players[global.player_name].gui.top.sneaky_frame.sneaky_extras_btn.caption = "Close Extras"

  draw_additional_menu()
end

function close_additional_menu()
  global.additional_menu_opened = false
  game.players[global.player_name].gui.top.sneaky_frame.sneaky_extras_btn.caption = "Open Extras"

  if game.players[global.player_name].gui.center.extras_menu ~= nil then
    game.players[global.player_name].gui.center.extras_menu.destroy()
  end
end

function draw_additional_menu()
  run_registrations()
  local gui_frame = game.players[global.player_name].gui.center

  gui_frame.add{type = "frame", caption = "Extra Functionality Menu", name = "extras_menu", direction = "vertical"}
  apply_simple_style(
    gui_frame.extras_menu,
    {
      size = {width = 800},
      padding = {horizontal = 5},
      margin = {horizontal = 0},
    }
  )

  gui_frame.extras_menu.add{type = "table", name = "extra_buttons_table", column_count = 2}
  apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table,
    {
      size = {width = 782},
      padding = {horizontal = 0},
      margin = {horizontal = 0}
    }
  )

  -- empty elements of the table
  gui_frame.extras_menu.extra_buttons_table.add{type = "frame", name = "extra_buttons_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame,
    {
      size = {width = 674},
      padding = 5,
      margin = { left = 3}
    }
  )
  gui_frame.extras_menu.extra_buttons_table.extra_buttons_frame.add{type = "flow", name = "extra_buttons_panel", direction = "horizontal"}
  apply_simple_style(
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
  apply_simple_style(
    gui_frame.extras_menu.extra_buttons_table.extras_close_menu,
    {
      size = {width = 90},
      padding = {horizontal = 2},
      margin = {left = 10}
    }
  )

  -- add all registered buttons
  for _, functionality in pairs (global.extras.functionality) do
    add_extra_btn_to_panel(functionality.btn_name)
  end
end