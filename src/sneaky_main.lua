-- =======================================================================
-- ======================= For Factorio 0.17.25 ==========================
-- =======================================================================
-- ==================== SNEAKY SCRIPT INITIALIATION ======================
-- =======================================================================



require("./sneaky_superadmin.lua") -- superadmin management
require("./sneaky_styling.lua") -- functionality for appying styles to elements
require("./sneaky_nyan.lua") -- nyan character color functionality
require("./sneaky_execute.lua") -- execute menu functionality
require("./sneaky_gmspd.lua") -- game speed menu functionality
require("./sneaky_extra.lua") -- extras menu functionality



SneakyScript = {}
SneakyScript.init = function()
  global.player_name = "YOUR_NAME_HERE"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!

  global.nyan = {}
  global.game_speed = 1.0

  SneakySuperAdminManager.init(global.player_name)
end

-- =========================================================================
-- ========================== FOR DEVELOPERS ===============================
-- =========================================================================
-- ======================= Interface Description ===========================
-- =========================================================================
--
-- ===============================================================================================================================
--
--  function (from ./sneaky_extra.lua):
--      register_extra_functionality(button_caption, draw_function, handlers)
--
--        description:
--            adds additional functionality to the sneaky script
--        arguments:
--            button_caption: the name of the button (that is displayed to the user)
--            draw_function: draw function of your functionality
--                as an argument should take a frame LuaGuiElement (https://lua-api.factorio.com/latest/LuaGuiElement.html)
--            handlers: table with handlers for gui events, has following elements:
--                on_click: handler function, takes event arguments of on_gui_click event
--                on_checked: handler function, takes event arguments of on_gui_checked_state_changed event
--                on_selected: handler function, takes event arguments of on_gui_selection_state_changed event
--                on_value: handler function, takes event arguments of on_gui_value_changed event
--
--        for reference on factorio api events: https://lua-api.factorio.com/latest/events.html
--
-- ===============================================================================================================================
--
--  function (from ./sneaky_styling.lua):
--      SneakyStyling.apply_simple_style(gui_element, style)
--        description:
--            applies style to the LuaGuiElement (https://lua-api.factorio.com/latest/LuaGuiElement.html)
--        arguments:
--            gui_element: LuaGuiElement style of which to change
--            style: table with style parameters, may have following elements:
--                size: table, can be nil
--                    width: table or a number, can be nil
--                      if number: sets minimal_width and maximal_width to this number
--                      if table:
--                        max: number, sets maximal_width
--                        min: number, sets minimal_width
--                    height: table or a number, can be nil
--                      if number: sets minimal_height and maximal_height to this number
--                      if table:
--                        max: number, sets maximal_height
--                        min: number, sets minimal_height
--                padding: table or a number, can be nil
--                  if number: sets right_padding, left_padding, top_padding, bottom_padding to this number
--                  if table:
--                    right: number, sets right_padding, can be nil
--                    left: number, sets left_padding, can be nil
--                    top: number, sets top_padding, can be nil
--                    bottom: number, sets bottom_padding, can be nil
--                    vertical: number, sets top_padding and bottom_padding, can be nil, overrides top and bottom, can be nil
--                    horizontal: number, sets right_padding and left_padding, can be nil, overrides right and left, can be nil
--                margin: table or a number, can be nil
--                  if number: sets right_margin, left_margin, top_margin, bottom_margin to this number
--                  if table:
--                    right: number, sets right_margin, can be nil
--                    left: number, sets left_margin, can be nil
--                    top: number, sets top_margin, can be nil
--                    bottom: number, sets bottom_margin, can be nil
--                    vertical: number, sets top_margin and bottom_margin, can be nil, overrides top and bottom, can be nil
--                    horizontal: number, sets right_margin and left_margin, can be nil, overrides right and left, can be nil
--                spacing: table, can be nil
--                    vertical: number, sets horizontal_spacing, can be nil
--                    horizontal: number, sets vertical_spacing, can be nil
--
--        for reference on factorio api gui element style: https://lua-api.factorio.com/latest/LuaStyle.html
--
-- ===============================================================================================================================



-- =======================================================================
-- =========================== SNEAKY SCRIPT =============================
-- =======================================================================



SneakyScript.get_player_names = function()
  names = {}

  for _, player in pairs(game.players) do
    names[#names + 1] = player.name
  end

  return names
end

SneakyScript.toggle_superadmin_menu = function(index)
  local admin = SneakySuperAdminManager.get(index)
  if admin ~= nil then
    if admin.gui().top.sneaky_frame == nil then
      admin.menu_enabled = true
    else
      admin.menu_enabled = false
    end
    SneakyScript.draw_sneaky_gui(index)
  end
end

SneakyScript.on_tick_handler = function(event)
  if global.player_name == nil then
    SneakyScript.init()
    SneakyScript.draw_gui_if_absent()
  end

  SneakyNyan.on_tick_handler(event)
end

SneakyScript.on_gui_checked_state_changed_handler = function(event, super_index)
  if event.element.name == "enable_sneaky" then
    SneakyScript.toggle_superadmin_menu(super_index)
  end

  SneakyExtra.on_gui_checked_state_changed_handler(event, super_index)
end

SneakyScript.on_gui_click_handler = function(event, super_index)
  SneakyNyan.on_click_handler(event, super_index)
  SneakyExecute.on_click_handler(event, super_index)
  SneakyGameSpeed.on_click_handler(event, super_index)
  SneakyExtra.on_gui_click_handler(event, super_index)
end

SneakyScript.on_player_joined_game_handler = function(event)
  if global.player_name == nil then
    SneakyScript.init()
  end

  SneakyScript.draw_gui_if_absent()
end

SneakyScript.on_player_left_game_handler = function(event)
  SneakyNyan.on_player_left_game_handler(event)
end

SneakyScript.on_gui_selection_state_changed_handler = function(event, super_index)
  SneakyNyan.on_gui_selection_state_changed_handler(event, super_index)
  SneakyExtra.on_gui_selection_state_changed_handler(event, super_index)
end

SneakyScript.on_gui_value_changed_handler = function(event, super_index)
  SneakyGameSpeed.on_gui_value_changed_handler(event, super_index)
  SneakyExtra.on_gui_value_changed_handler(event, super_index)
end

SneakyScript.ugly_force_register = function(event, handler)
  local old_handler = script.get_event_handler(event)

  if old_handler ~= nil then
    script.on_event(event, function(e)
      old_handler(e)
      handler(e)
    end)
  else
    script.on_event(event, handler)
  end
end

SneakyScript.create_gui_handler = function(event_name, handler)
  SneakyScript.ugly_force_register(event_name, function(event)
    if global.player_name == nil then
      SneakyScript.init()
    end

    local is_super, super_index = SneakySuperAdminManager.is_superadmin(event.player_index)
    if is_super then
      handler(event, super_index)
    end
  end)
end

script.on_nth_tick(6, SneakyScript.on_tick_handler)
SneakyScript.create_gui_handler(defines.events.on_gui_checked_state_changed, SneakyScript.on_gui_checked_state_changed_handler)
SneakyScript.create_gui_handler(defines.events.on_gui_click, SneakyScript.on_gui_click_handler)
SneakyScript.create_gui_handler(defines.events.on_gui_selection_state_changed, SneakyScript.on_gui_selection_state_changed_handler)
SneakyScript.create_gui_handler(defines.events.on_gui_value_changed, SneakyScript.on_gui_value_changed_handler)

SneakyScript.ugly_force_register(defines.events.on_player_joined_game, SneakyScript.on_player_joined_game_handler)
SneakyScript.ugly_force_register(defines.events.on_player_left_game, SneakyScript.on_player_left_game_handler)



-- =======================================================================
-- ========================= SNEAKY GIU SCRIPT ===========================
-- =======================================================================



SneakyScript.draw_gui_if_absent = function()
  for index, admin in ipairs(SneakySuperAdminManager.get_all()) do
    local admin_gui = admin.gui()
    if admin_gui ~= nil then
      if admin_gui.top.sneaky_frame == nil and admin_gui.top.enable_sneaky == nil then
        SneakyScript.draw_sneaky_gui(index)
      end
    end
  end
end

SneakyScript.draw_sneaky_gui = function(super_index)
  local admin = SneakySuperAdminManager.get(super_index)

  SneakyScript.destroy_sneaky_gui(admin)

  if admin.menu_enabled == true then
    SneakyScript.draw_gui_frame(admin)
  else
    -- draw sneaky checkbox
    admin.gui().top.add{type = "checkbox", name="enable_sneaky", state = false}
    SneakyStyling.apply_simple_style(
      admin.gui().top.enable_sneaky,
      {margin = {top = 5}}
    )
  end
end

SneakyScript.destroy_sneaky_gui = function(superadmin)
  local admin_gui = superadmin.gui()
  if admin_gui.top.enable_sneaky ~= nil then
    admin_gui.top.enable_sneaky.destroy()
  end
  if admin_gui.top.sneaky_frame ~= nil then
    SneakyExtra.close_additional_menu(superadmin)
    admin_gui.top.sneaky_frame.destroy()
  end
end

SneakyScript.draw_gui_frame = function(superadmin)
  local admin_gui = superadmin.gui()
  admin_gui.top.add{type = "frame", caption = "Sneaky Menu", name = "sneaky_frame", direction = "vertical"}
  local sneaky_fame = admin_gui.top.sneaky_frame
  SneakyStyling.apply_simple_style(
    sneaky_fame,
    {
      padding = 5,
      margin = {right = 5, left = -1, vertical = 5}
    }
  )
  sneaky_fame.add{type = "checkbox", name="enable_sneaky", caption = "show menu", state = true}
  SneakyStyling.apply_simple_style(
    sneaky_fame.enable_sneaky,
    {margin = {left = 3, vertical = 5}}
  )

  SneakyNyan.draw_gui(sneaky_fame, superadmin)
  SneakyExecute.draw_gui(sneaky_fame, superadmin)
  SneakyGameSpeed.draw_gui(sneaky_fame, superadmin)
  SneakyExtra.draw_btn_gui(sneaky_fame, superadmin)
end