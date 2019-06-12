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
  KMinimalistBootstrap.init()

  global.player_name = "k-Knight"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!

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
      {top_margin = 5}
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
    {vertical_margin = 5, right_margin = 5, left_margin = -1, padding = 5}
  )
  fsac_fame.add{type = "checkbox", name="enable_fsac", caption = "show menu", state = true}
  KMinimalistStyling.apply_style(
    fsac_fame.enable_fsac,
    {vertical_margin = 5, left_margin = 3}
  )

  FSACNyan.draw_gui(fsac_fame, superadmin)
  FSACExecute.draw_gui(fsac_fame, superadmin)
  FSACGameSpeed.draw_gui(fsac_fame, superadmin)
  FSACExtra.draw_btn_gui(fsac_fame, superadmin)
end