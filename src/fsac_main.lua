-- =======================================================================
-- ======================= For Factorio 0.17.25 ==========================
-- =======================================================================
-- ===================== FSAC SCRIPT INITIALIATION =======================
-- =======================================================================



require("./kminimalist_bootstrap.lua") -- KMinimalist Bootstrap
require("./kminimalist_safe_api_object.lua") -- KMinimalist Safe Api Object (api object proxy)
require("./kminimalist_styling.lua") -- KMinimalist Styling (appying styles to elements)

require("./fasc_super_admin_manager.lua") -- superadmin management
require("./fsac_nyan.lua") -- nyan character color functionality
require("./fsac_execute.lua") -- execute menu functionality
require("./fsac_game_speed.lua") -- game speed menu functionality
require("./fsac_extra.lua") -- extras menu functionality



FSACMainScript = {}
FSACMainScript.init = function()
  global.player_name = "YOUR_NAME_HERE"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!

  global.nyan = {}
  global.game_speed = 1.0

  FSACSuperAdminManager.init(global.player_name)
end

-- =========================================================================
-- ========================== FOR DEVELOPERS ===============================
-- =========================================================================
-- ======================= Interface Description ===========================
-- =========================================================================
--
-- ===============================================================================================================================
--
--  function (from ./fsac_extra.lua):
--      FSACExtra.register_extra_functionality(button_caption, draw_function, handlers)
--
--        description:
--            adds additional functionality to the FSAC script
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
--  function (from ./kminimalist_styling.lua):
--      KMinimalistStyling.apply_style(gui_element, style)
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
--                    vertical: number, sets vertical_spacing, can be nil
--                    horizontal: number, sets horizontal_spacing, can be nil
--                align: table, can be nil
--                    vertical: string ("top", "center" or "bottom"), sets vertical_align, can be nil
--                    horizontal: string ("left", "center" or "right"), sets horizontal_align, can be nil
--
--        for reference on factorio api gui element style: https://lua-api.factorio.com/latest/LuaStyle.html
--
-- ===============================================================================================================================



-- =======================================================================
-- ============================ FSAC SCRIPT ==============================
-- =======================================================================



FSACMainScript.get_player_names = function()
  names = {}

  for _, player in pairs(game.players) do
    names[#names + 1] = player.name
  end

  return names
end

FSACMainScript.toggle_superadmin_menu = function(index)
  local admin = FSACSuperAdminManager.get(index)
  if admin ~= nil then
    if admin:get_gui().top.fsac_frame.is_nil then
      admin.menu_enabled = true
    else
      admin.menu_enabled = false
    end
    FSACMainScript.draw_fsac_gui(index)
  end
end

FSACMainScript.on_tick_handler = function(event)
  if global.player_name == nil then
    FSACMainScript.init()
    FSACMainScript.draw_gui_if_absent()
  end

  FSACNyan.on_tick_handler(event)
end

FSACMainScript.on_gui_checked_state_changed_handler = function(event, super_index)
  if event.element.name == "enable_fsac" then
    FSACMainScript.toggle_superadmin_menu(super_index)
  end

  FSACExtra.on_gui_checked_state_changed_handler(event, super_index)
end

FSACMainScript.on_gui_click_handler = function(event, super_index)
  FSACNyan.on_click_handler(event, super_index)
  FSACExecute.on_click_handler(event, super_index)
  FSACGameSpeed.on_click_handler(event, super_index)
  FSACExtra.on_gui_click_handler(event, super_index)
end

FSACMainScript.on_player_joined_game_handler = function(event)
  if global.player_name == nil then
    FSACMainScript.init()
  end

  local is_super, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)
  if is_super then
    local admin = FSACSuperAdminManager.get(super_index)
    admin.menu_enabled = false
    FSACMainScript.destroy_fsac_gui(admin)
  end
  FSACMainScript.draw_gui_if_absent()
end

FSACMainScript.on_player_left_game_handler = function(event)
  FSACNyan.on_player_left_game_handler(event)
end

FSACMainScript.on_gui_selection_state_changed_handler = function(event, super_index)
  FSACNyan.on_gui_selection_state_changed_handler(event, super_index)
  FSACExtra.on_gui_selection_state_changed_handler(event, super_index)
end

FSACMainScript.on_gui_value_changed_handler = function(event, super_index)
  FSACGameSpeed.on_gui_value_changed_handler(event, super_index)
  FSACExtra.on_gui_value_changed_handler(event, super_index)
end

KMinimalistBootstrap.register = function(event, handler)
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

FSACMainScript.create_gui_handler = function(event_name, handler)
  KMinimalistBootstrap.register(event_name, function(event)
    if global.player_name == nil then
      FSACMainScript.init()
    end

    local is_super, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)
    if is_super then
      handler(KMinimalistSafeApiObject.new(event), super_index)
    end
  end)
end

script.on_nth_tick(6, FSACMainScript.on_tick_handler)
FSACMainScript.create_gui_handler(defines.events.on_gui_checked_state_changed, FSACMainScript.on_gui_checked_state_changed_handler)
FSACMainScript.create_gui_handler(defines.events.on_gui_click, FSACMainScript.on_gui_click_handler)
FSACMainScript.create_gui_handler(defines.events.on_gui_selection_state_changed, FSACMainScript.on_gui_selection_state_changed_handler)
FSACMainScript.create_gui_handler(defines.events.on_gui_value_changed, FSACMainScript.on_gui_value_changed_handler)

KMinimalistBootstrap.register(defines.events.on_player_joined_game, FSACMainScript.on_player_joined_game_handler)
KMinimalistBootstrap.register(defines.events.on_player_left_game, FSACMainScript.on_player_left_game_handler)



-- =======================================================================
-- ========================== FSAC GIU SCRIPT ============================
-- =======================================================================



FSACMainScript.draw_gui_if_absent = function()
  for index, admin in ipairs(FSACSuperAdminManager.get_all()) do
    local admin_gui = admin:get_gui()
      if admin_gui.top.fsac_frame.is_nil and admin_gui.top.enable_fsac.is_nil then
        FSACMainScript.draw_fsac_gui(index)
      end
  end
end

FSACMainScript.draw_fsac_gui = function(super_index)
  local admin = FSACSuperAdminManager.get(super_index)

  FSACMainScript.destroy_fsac_gui(admin)

  if admin.menu_enabled == true then
    FSACMainScript.draw_gui_frame(admin)
  else
    admin:get_gui().top.add{type = "checkbox", name="enable_fsac", state = false}
    KMinimalistStyling.apply_style(
      admin:get_gui().top.enable_fsac,
      {margin = {top = 5}}
    )
  end
end

FSACMainScript.destroy_fsac_gui = function(superadmin)
  local admin_gui = superadmin:get_gui()

  admin_gui.top.enable_fsac.destroy()
  FSACExtra.close_additional_menu(superadmin)
  admin_gui.top.fsac_frame.destroy()
end

FSACMainScript.draw_gui_frame = function(superadmin)
  local admin_gui = superadmin:get_gui()
  admin_gui.top.add{type = "frame", caption = "fsac Menu", name = "fsac_frame", direction = "vertical"}
  local fsac_fame = admin_gui.top.fsac_frame
  KMinimalistStyling.apply_style(
    fsac_fame,
    {
      padding = 5,
      margin = {right = 5, left = -1, vertical = 5}
    }
  )
  fsac_fame.add{type = "checkbox", name="enable_fsac", caption = "show menu", state = true}
  KMinimalistStyling.apply_style(
    fsac_fame.enable_fsac,
    {margin = {left = 3, vertical = 5}}
  )

  FSACNyan.draw_gui(fsac_fame, superadmin)
  FSACExecute.draw_gui(fsac_fame, superadmin)
  FSACGameSpeed.draw_gui(fsac_fame, superadmin)
  FSACExtra.draw_btn_gui(fsac_fame, superadmin)
end