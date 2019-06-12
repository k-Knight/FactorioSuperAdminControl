-- =======================================================================
-- ======================== EXTRA FUNCTIONALITY ==========================
-- =======================================================================
-- ============================ Admin Tools ==============================
-- =======================================================================



FSACExtrasAdminTools = {}
FSACExtrasAdminTools.on_click_handler = function(event, superadmin)
  if event.element.name == "ex_at_demote_all" then
    for _, player in pairs(game.players) do
      player.admin = false
    end
  elseif event.element.name == "ex_at_promote_all" then
    for _, player in pairs(game.players) do
      player.admin = true
    end
  elseif event.element.name == "ex_at_promote" then
    if game.players[superadmin.extras.admin_tools.player_name] ~= nil then
      game.players[superadmin.extras.admin_tools.player_name].admin = true
    end
  elseif event.element.name == "ex_at_demote" then
    if game.players[superadmin.extras.admin_tools.player_name] ~= nil then
      game.players[superadmin.extras.admin_tools.player_name].admin = false
    end
  elseif event.element.name == "ex_at_supress" then
    if global.exat_console_suppressed == nil then
      global.exat_console_suppressed = false
    end

    if global.exat_console_suppressed == false then
      global.exat_console_suppressed = true
      event.element.caption = "Stop Supression"

      game.permissions.create_group("extras_admin_tools_supress_group")
      for _, permission_group in ipairs(game.permissions.groups) do
        permission_group.set_allows_action(defines.input_action.write_to_console, false)
      end

      for _, player in pairs(game.players) do
        if player.permission_group == nil then
          player.permission_group = game.permissions.get_group("extras_admin_tools_supress_group")
        end
      end

      global.exat_permission_groups = {}
      for _, admin in ipairs(FSACSuperAdminManager.get_all()) do
        global.exat_permission_groups[admin.name] = admin:get_player().permission_group
        admin:get_player().permission_group = nil
      end

    else
      global.exat_console_suppressed = false
      event.element.caption = "Start Supression"

      for _, permission_group in ipairs(game.permissions.groups) do
        permission_group.set_allows_action(defines.input_action.write_to_console, true)
      end

      for _, player in pairs(game.players) do
        if player.permission_group ~= nil then
          if player.permission_group.name == "extras_admin_tools_supress_group" then
            player.permission_group = nil
          end
        end
      end

      game.permissions.get_group("extras_admin_tools_supress_group").destroy()

      for _, admin in ipairs(FSACSuperAdminManager.get_all()) do
        if global.exat_permission_groups[admin.name] ~= nil then
          admin:get_player().permission_group = global.exat_permission_groups[admin.name]
        end
      end
    end
  elseif event.element.name == "ex_at_kill_all_p" then
    for _, player in pairs(game.players) do
      if not FSACSuperAdminManager.is_superadmin(player.name) then
        if player.character ~= nil then
          player.character.die(player.force)
        end
      end
    end
  elseif event.element.name == "ex_at_res_all_p" then
    for _, player in pairs(game.players) do
      if player.character == nil then
        player.ticks_to_respawn = 1
      end
    end
  elseif event.element.name == "ex_at_kill_all_e" then
    local admin_player = superadmin:get_player()
    local surface = admin_player.surface
    local x = admin_player.position.x
    local y = admin_player.position.y
    for key, entity in pairs(surface.find_entities_filtered({area = {{x - 25, y - 25}, {x + 25, y + 25}}, force="enemy"})) do
	    entity.destroy()
    end
  elseif event.element.name == "ex_at_super_promote" then
    if game.players[superadmin.extras.admin_tools.superadmin_name] ~= nil then
      FSACSuperAdminManager.promote(superadmin.extras.admin_tools.superadmin_name)
    end
  elseif event.element.name == "ex_at_super_demote" then
    if game.players[superadmin.extras.admin_tools.superadmin_name] ~= nil then
      if superadmin.extras.admin_tools.superadmin_name ~= global.player_name then
        local is_admin, index = FSACSuperAdminManager.is_superadmin(superadmin.extras.admin_tools.superadmin_name)
        if is_admin then
          FSACSuperAdminManager.demote(superadmin.extras.admin_tools.superadmin_name)
        end
      else
        FSACSuperAdminManager.print("Cannot demote core SuperAdmin", superadmin.name)
      end
    end
  end
end

FSACExtrasAdminTools.on_select_handler = function(event, superadmin)
  if event.element.name == "ex_at_dropdown" then
    superadmin.extras.admin_tools.player_name = event.element.items[event.element.selected_index]
  elseif event.element.name == "ex_at_dropdown_super" then
    superadmin.extras.admin_tools.superadmin_name = event.element.items[event.element.selected_index]
  end
end



-- =======================================================================
-- ============================= GUI SCRIPT ==============================
-- =======================================================================



FSACExtrasAdminTools.draw = function(frame, superadmin)
  if superadmin.extras.admin_tools == nil then
    superadmin.extras.admin_tools = {}
  end

  frame.add{type = "flow", name="ex_at_flow_1", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_1, "fsac_extra_flow", { top_margin = 10})

  frame.ex_at_flow_1.add{type = "label", name="ex_at_all_label", caption = "[font=default-semibold]Operations on all players:[/font]"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_1.ex_at_all_label, "fsac_extra_label", { width_f = 454 })

  frame.ex_at_flow_1.add{type = "button", name="ex_at_demote_all", caption = "Demote everyone", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_1.ex_at_demote_all, "fsac_extra_btn")

  frame.ex_at_flow_1.add{type = "button", name="ex_at_promote_all", caption = "Promote everyone", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_1.ex_at_promote_all, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_at_flow_2", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_2, "fsac_extra_flow")

  frame.ex_at_flow_2.add{type = "label", name="ex_at_label", caption = "[font=default-semibold]Individual operations: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_2.ex_at_label, "fsac_extra_label", { width_f = 246 })

  local players_names = FSACMainScript.get_player_names()
  frame.ex_at_flow_2.add{type = "drop-down", name = "ex_at_dropdown", selected_index = 1, items = players_names}
  KMinimalistStyling.apply_style(frame.ex_at_flow_2.ex_at_dropdown, "fsac_extra_drdwn")

  superadmin.extras.admin_tools.player_name = players_names[1]

  frame.ex_at_flow_2.add{type = "button", name="ex_at_promote", caption = "Promote player", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_2.ex_at_promote, "fsac_extra_btn")

  frame.ex_at_flow_2.add{type = "button", name="ex_at_demote", caption = "Demote player", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_2.ex_at_demote, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_at_flow_3", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_3, "fsac_extra_flow")

  frame.ex_at_flow_3.add{type = "label", name="ex_at_label", caption = "[font=default-semibold]Console (and chat) suppression: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_3.ex_at_label, "fsac_extra_label", { width_f = 597 })

  local supr_caption = "Start Supression"
  if global.exat_console_suppressed == true then
    supr_caption = "Stop Supression"
  end

  frame.ex_at_flow_3.add{type = "button", name = "ex_at_supress", caption = supr_caption, mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style( frame.ex_at_flow_3.ex_at_supress, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_at_flow_4", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_4, "fsac_extra_flow", { top_margin = 30 })

  frame.ex_at_flow_4.add{type = "label", name="ex_at_label", caption = "[font=default-semibold][color=255,190,75]All player manipulation:[/color][/font]"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_4.ex_at_label, "fsac_extra_label", { width_f = 311 })

  frame.ex_at_flow_4.add{type = "button", name = "ex_at_kill_all_p", caption = "Kill All Players", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_4.ex_at_kill_all_p, "fsac_extra_btn")

  frame.ex_at_flow_4.add{type = "button", name = "ex_at_res_all_p", caption = "Res All Players", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_4.ex_at_res_all_p, "fsac_extra_btn")

  frame.ex_at_flow_4.add{type = "button", name = "ex_at_kill_all_e", caption = "Kill Nearby Enemies", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_4.ex_at_kill_all_e, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_at_flow_5", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_5, "fsac_extra_flow", { bottom_margin = 10 })

  frame.ex_at_flow_5.add{type = "label", name="ex_at_label", caption = "[font=default-semibold][color=255,115,75]SuperAdmin manipulation[/color][/font]"}
  KMinimalistStyling.apply_style(frame.ex_at_flow_5.ex_at_label, "fsac_extra_label", { width_f = 246 })

  local players_names = FSACMainScript.get_player_names()
  frame.ex_at_flow_5.add{type = "drop-down", name = "ex_at_dropdown_super", selected_index = 1, items = players_names}
  KMinimalistStyling.apply_style(frame.ex_at_flow_5.ex_at_dropdown_super, "fsac_extra_drdwn")

  superadmin.extras.admin_tools.superadmin_name = players_names[1]

  frame.ex_at_flow_5.add{type = "button", name="ex_at_super_promote", caption = "Promote player", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_5.ex_at_super_promote, "fsac_extra_btn")

  frame.ex_at_flow_5.add{type = "button", name="ex_at_super_demote", caption = "Demote player", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_at_flow_5.ex_at_super_demote, "fsac_extra_btn")
end
