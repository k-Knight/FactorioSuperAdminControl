-- =======================================================================
-- ======================= For Factorio 0.17.64 ==========================
-- =======================================================================
-- ===================== FSAC SCRIPT INITIALIATION =======================
-- =======================================================================



require("kminimalist/kminimalist_bootstrap.lua") -- KMinimalist Bootstrap
require("kminimalist/kminimalist_safe_api_object.lua") -- KMinimalist Safe Api Object (api object proxy)
require("kminimalist/kminimalist_styling.lua") -- KMinimalist Styling (appying styles to elements)

require("./fasc_super_admin_manager.lua") -- superadmin management
require("./fsac_nyan.lua") -- nyan character color functionality
require("./fsac_execute.lua") -- execute menu functionality
require("./fsac_game_speed.lua") -- game speed menu functionality
require("./fsac_extra.lua") -- extra menu functionality

require("./extra/fsac_extra_admin_tools.lua") -- [extra module]: Admin Tools
require("./extra/fsac_extra_player_tools.lua") -- [extra module]: Player Tools



FSACMainScript = {}
FSACMainScript.init = function()
  KMinimalistBootstrap.init()

  global.player_name = "k-Knight"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!

  global.nyan = {}
  global.game_speed = 1.0

  FSACSuperAdminManager.init(global.player_name)
end

FSACMainScript.version = "0.1.0.1"

FSACMainScript.check_version = function()
  if global.fsac_version == nil then
    global.fsac_version = FSACMainScript.version
    global.player_name = nil
  end
end

if global.fsac_version ~= FSACMainScript.version then
  init_function = FSACMainScript.init

  FSACMainScript.init = function()
    local superadmins = FSACSuperAdminManager.get_all()
    local admin_names = {}
    for _, superadmin in pairs(superadmins) do
      admin_names[#admin_names + 1] = superadmin.name
    end

    for _, name in pairs(admin_names) do
      FSACSuperAdminManager.demote(name)
    end

    init_function()

    for _, name in pairs(admin_names) do
      FSACSuperAdminManager.promote(name)
    end
  end
end



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

FSACMainScript.on_gui_checked_state_changed_handler = function(event)
  FSACMainScript.check_version()

  if global.player_name == nil then
    FSACMainScript.init()
    return
  end

  event = KMinimalistSafeApiObject.new(event)
  is_admin, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)

  if is_admin then
    if event.element.name == "enable_fsac" then
      FSACMainScript.toggle_superadmin_menu(super_index)
    end

    FSACExtra.on_gui_checked_state_changed_handler(event, super_index)
  end
end

FSACMainScript.on_gui_click_handler = function(event)
  FSACMainScript.check_version()

  if global.player_name == nil then
    FSACMainScript.init()
    return
  end

  event = KMinimalistSafeApiObject.new(event)
  is_admin, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)

  if is_admin then
    FSACNyan.on_click_handler(event, super_index)
    FSACExecute.on_click_handler(event, super_index)
    FSACGameSpeed.on_click_handler(event, super_index)
    FSACExtra.on_gui_click_handler(event, super_index)
  end
end

FSACMainScript.on_player_joined_game_handler = function(event)
  FSACMainScript.check_version()

  if global.player_name == nil then
    FSACMainScript.init()
  end

  event = KMinimalistSafeApiObject.new(event)

  local is_super, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)
  if is_super then
    local admin = FSACSuperAdminManager.get(super_index)
    admin.menu_enabled = false
    FSACMainScript.destroy_fsac_gui(admin)
  end
  FSACMainScript.draw_gui_if_absent()
end

FSACMainScript.on_player_left_game_handler = function(event)
  event = KMinimalistSafeApiObject.new(event)
  FSACNyan.on_player_left_game_handler(event)
end

FSACMainScript.on_gui_selection_state_changed_handler = function(event)
  event = KMinimalistSafeApiObject.new(event)
  is_admin, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)

  if is_admin then
    FSACNyan.on_gui_selection_state_changed_handler(event, super_index)
    FSACExtra.on_gui_selection_state_changed_handler(event, super_index)
  end
end

FSACMainScript.on_gui_value_changed_handler = function(event)
  event = KMinimalistSafeApiObject.new(event)
  is_admin, super_index = FSACSuperAdminManager.is_superadmin(event.player_index)

  if is_admin then
    FSACGameSpeed.on_gui_value_changed_handler(event, super_index)
    FSACExtra.on_gui_value_changed_handler(event, super_index)
  end
end



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

FSACMainScript.on_nth_tick = {}
FSACMainScript.on_nth_tick[6] = FSACMainScript.on_tick_handler

FSACMainScript.events = {
  [defines.events.on_player_joined_game] = FSACMainScript.on_player_joined_game_handler,
  [defines.events.on_player_left_game] = FSACMainScript.on_player_left_game_handler,
  [defines.events.on_gui_click] = FSACMainScript.on_gui_click_handler,
  [defines.events.on_gui_checked_state_changed] = FSACMainScript.on_gui_checked_state_changed_handler,
  [defines.events.on_gui_selection_state_changed] = FSACMainScript.on_gui_selection_state_changed_handler,
  [defines.events.on_gui_value_changed] = FSACMainScript.on_gui_value_changed_handler
}

return FSACMainScript