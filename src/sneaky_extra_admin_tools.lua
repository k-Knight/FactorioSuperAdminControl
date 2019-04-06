-- =======================================================================
-- ======================== EXTRA FUNCTIONALITY ==========================
-- =======================================================================
-- ============================ Admin Tools ==============================
-- =======================================================================



function extras_admin_tools_on_click_handler(event)
  if event.element.name == "ex_at_demote_all" then
    for _, player in pairs(game.players) do
      player.admin = false
    end
  elseif event.element.name == "ex_at_promote_all" then
    for _, player in pairs(game.players) do
      player.admin = true
    end
  elseif event.element.name == "ex_at_promote" then
    if game.players[global.extras.admin_tools.player_name] ~= nil then
      game.players[global.extras.admin_tools.player_name].admin = true
    end
  elseif event.element.name == "ex_at_demote" then
    if game.players[global.extras.admin_tools.player_name] ~= nil then
      game.players[global.extras.admin_tools.player_name].admin = false
    end
  elseif event.element.name == "ex_at_supress" then
    if global.extras.admin_tools.console_suppressed == nil then
      global.extras.admin_tools.console_suppressed = false
    end

    if global.extras.admin_tools.console_suppressed == false then
      global.extras.admin_tools.console_suppressed = true
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

      global.extras.admin_tools.permission_group = game.players[global.player_name].permission_group
      game.players[global.player_name].permission_group = nil

    else
      global.extras.admin_tools.console_suppressed = false
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
      game.players[global.player_name].permission_group = global.extras.admin_tools.permission_group
    end
  elseif event.element.name == "ex_at_kill_all_p" then
    for _, player in pairs(game.players) do
      if player.name ~= global.player_name then
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
    local surface = game.players[global.player_name].surface
    local x = game.players[global.player_name].position.x
    local y = game.players[global.player_name].position.y
    for key, entity in pairs(surface.find_entities_filtered({area = {{x - 25, y - 25}, {x + 25, y + 25}}, force="enemy"})) do
	    entity.destroy()
    end
  end
end

function extras_admin_tools_on_select_handler(event)
  if event.element.name == "ex_at_dropdown" then
    global.extras.admin_tools.player_name = event.element.items[event.element.selected_index]
  end
end



-- =======================================================================
-- ============================= GUI SCRIPT ==============================
-- =======================================================================



function extras_admin_tools_draw(frame)
  if global.extras.admin_tools == nil then
    global.extras.admin_tools = {}
  end

  frame.add{type = "flow", name="ex_at_flow_1", direction="horizontal"}
  apply_simple_style(
    frame.ex_at_flow_1,
    {
      margin = {horizontal = 5, top = 10},
      spacing = {horizontal = 8}
    }
  )
  frame.ex_at_flow_1.add{type = "label", name="ex_at_all_label", caption = "Operations on all players: "}
  apply_simple_style(
    frame.ex_at_flow_1.ex_at_all_label,
    {
      size = {width = 454},
      padding = 0,
      margin = 0
    }
  )

  frame.ex_at_flow_1.add{type = "button", name="ex_at_demote_all", caption = "Demote everyone", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_1.ex_at_demote_all,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )
  frame.ex_at_flow_1.add{type = "button", name="ex_at_promote_all", caption = "Promote everyone", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_1.ex_at_promote_all,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )

  frame.add{type = "flow", name="ex_at_flow_2", direction="horizontal"}
  apply_simple_style(
    frame.ex_at_flow_2,
    {
      margin = {horizontal = 5, top = 5},
      spacing = {horizontal = 8}
    }
  )
  frame.ex_at_flow_2.add{type = "label", name="ex_at_label", caption = "Individual operations: "}
  apply_simple_style(
    frame.ex_at_flow_2.ex_at_label,
    {
      size = {width = 246},
      padding = 0,
      margin = 0
    }
  )

  local players_names = get_player_names()
  frame.ex_at_flow_2.add{type = "drop-down", name = "ex_at_dropdown", selected_index = 1, items = players_names}
  apply_simple_style(
    frame.ex_at_flow_2.ex_at_dropdown,
    {size = {width = 200}}
  )
  global.extras.admin_tools.player_name = players_names[1]

  frame.ex_at_flow_2.add{type = "button", name="ex_at_promote", caption = "Promote player", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_2.ex_at_promote,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )
  frame.ex_at_flow_2.add{type = "button", name="ex_at_demote", caption = "Demote player", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_2.ex_at_demote,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )

  frame.add{type = "flow", name="ex_at_flow_3", direction="horizontal"}
  apply_simple_style(
    frame.ex_at_flow_3,
    {
      margin = {horizontal = 5, top = 5, bottom = 10},
      spacing = {horizontal = 8}
    }
  )
  frame.ex_at_flow_3.add{type = "label", name="ex_at_label", caption = "Console (and chat) suppression: "}
  apply_simple_style(
    frame.ex_at_flow_3.ex_at_label,
    {
      size = {width = 597},
      padding = 0,
      margin = 0
    }
  )

  local supr_caption = "Start Supression"
  if global.extras.admin_tools.console_suppressed == true then
    supr_caption = "Stop Supression"
  end

  frame.ex_at_flow_3.add{type = "button", name = "ex_at_supress", caption = supr_caption, mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_3.ex_at_supress,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )

  frame.add{type = "flow", name="ex_at_flow_4", direction="horizontal"}
  apply_simple_style(
    frame.ex_at_flow_4,
    {
      margin = {horizontal = 5, top = 30, bottom = 10},
      spacing = {horizontal = 8}
    }
  )
  frame.ex_at_flow_4.add{type = "label", name="ex_at_label", caption = "All player manipulation: "}
  apply_simple_style(
    frame.ex_at_flow_4.ex_at_label,
    {
      size = {width = 311},
      padding = 0,
      margin = 0
    }
  )

  frame.ex_at_flow_4.add{type = "button", name = "ex_at_kill_all_p", caption = "Kill All Players", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_4.ex_at_kill_all_p,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )

  frame.ex_at_flow_4.add{type = "button", name = "ex_at_res_all_p", caption = "Res All Players", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_4.ex_at_res_all_p,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )

  frame.ex_at_flow_4.add{type = "button", name = "ex_at_kill_all_e", caption = "Kill Nearby Enemies", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_at_flow_4.ex_at_kill_all_e,
    {
      size = {width = 135},
      padding = {horizontal = 2},
      margin = {horizontal = 0}
    }
  )
end
