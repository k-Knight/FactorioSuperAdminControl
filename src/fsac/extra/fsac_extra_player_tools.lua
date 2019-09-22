-- =======================================================================
-- ======================== EXTRA FUNCTIONALITY ==========================
-- =======================================================================
-- =========================== Player Tools ==============================
-- =======================================================================



FSACExtraPlayerTools = {}
FSACExtraPlayerTools.set_gui_values = function(admin, player)
  FSACExtra.get_wrapper_frame(admin).ex_pt_flow_5.ex_pt_craft_slider.slider_value = 0.0
  FSACExtra.get_wrapper_frame(admin).ex_pt_flow_6.ex_pt_mine_slider.slider_value = 0.0
  FSACExtra.get_wrapper_frame(admin).ex_pt_flow_7.ex_pt_run_slider.slider_value = 0.0

  if player ~= nil then
    FSACExtra.get_wrapper_frame(admin).ex_pt_flow_2.ex_pt_cheat_checkbox.state = player.cheat_mode
    FSACExtra.get_wrapper_frame(admin).ex_pt_flow_2.ex_pt_cheat_checkbox.enabled = true
    if player.character ~= nil then
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_5.ex_pt_craft_slider.slider_value = player.character_crafting_speed_modifier
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_5.ex_pt_craft_slider.enabled = true
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_6.ex_pt_mine_slider.slider_value = player.character_mining_speed_modifier
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_6.ex_pt_mine_slider.enabled = true
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_7.ex_pt_run_slider.slider_value = player.character_running_speed_modifier
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_7.ex_pt_run_slider.enabled = true
    else
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_5.ex_pt_craft_slider.enabled = false
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_6.ex_pt_mine_slider.enabled = false
      FSACExtra.get_wrapper_frame(admin).ex_pt_flow_7.ex_pt_run_slider.enabled = false
    end
  else
    FSACExtra.get_wrapper_frame(admin).ex_pt_flow_2.ex_pt_cheat_checkbox.state = false
    FSACExtra.get_wrapper_frame(admin).ex_pt_flow_2.ex_pt_cheat_checkbox.enabled = false
  end
end

FSACExtraPlayerTools.update_values = function(player)
  if player ~= nil then
    for _, admin in ipairs(FSACSuperAdminManager.get_all()) do
      if admin.extras.player_tools ~= nil then
        local admin_player = game.players[admin.extras.player_tools.player_name]
        if admin_player ~= nil then
          if admin_player.name == player.name then
            FSACExtraPlayerTools.set_gui_values(admin, player)
          end
        end
      end
    end
  end
end

FSACExtraPlayerTools.clear_armor = function(player)
  if player.character ~= nil then
    local p_armor = player.get_inventory(defines.inventory.character_armor)[1]
    if p_armor ~= nil then
      p_armor.clear()
    end
  end
end

FSACExtraPlayerTools.delete_all_armor = function(player)
  if player.character ~= nil then
    FSACExtraPlayerTools.clear_armor(player)
    player.get_main_inventory().remove({name="power-armor-mk2", count = 4294967294})
    player.get_main_inventory().remove({name="power-armor", count = 4294967294})
    player.get_main_inventory().remove({name="modular-armor", count = 4294967294})
    player.get_main_inventory().remove({name="heavy-armor", count = 4294967294})
    player.get_main_inventory().remove({name="light-armor", count = 4294967294})
  end
end

FSACExtraPlayerTools.give_op_armor = function(player)
  if player.character ~= nil then
    player.insert{name="power-armor-mk2", count = 1}
    local p_armor = player.get_inventory(defines.inventory.character_armor)[1].grid
    p_armor.put({name = "fusion-reactor-equipment"})
    p_armor.put({name = "fusion-reactor-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "exoskeleton-equipment"})
    p_armor.put({name = "energy-shield-mk2-equipment"})
    p_armor.put({name = "energy-shield-mk2-equipment"})
    p_armor.put({name = "energy-shield-mk2-equipment"})
    p_armor.put({name = "energy-shield-mk2-equipment"})
    p_armor.put({name = "personal-roboport-mk2-equipment"})
    p_armor.put({name = "night-vision-equipment"})
    p_armor.put({name = "battery-mk2-equipment"})
    p_armor.put({name = "battery-mk2-equipment"})
  end
end

FSACExtraPlayerTools.teleport_to_player = function(superadmin)
  local player = KMinimalistSafeApiObject.new(game.players[superadmin.extras.player_tools.player_name])
  local target_player = KMinimalistSafeApiObject.new(game.players[superadmin.extras.player_tools.tp_player_name])

  local available_position = target_player.surface.find_non_colliding_position("character", target_player.position, 10.0, 0.25)
  if available_position ~= nil then
    player.teleport(available_position)
  end
end

FSACExtraPlayerTools.teleport_to_position = function(superadmin)
  local player = KMinimalistSafeApiObject.new(game.players[superadmin.extras.player_tools.player_name])
  local extra_gui = FSACExtra.get_wrapper_frame(superadmin)
  local x_pos = tonumber(extra_gui.ex_pt_flow_10.x_pos_string.text)
  local y_pos = tonumber(extra_gui.ex_pt_flow_10.y_pos_string.text)

  if x_pos ~= nil and y_pos ~= nil then
    player.teleport({x_pos, y_pos})
  end
end

FSACExtraPlayerTools.teleport_to_corpse = function(superadmin)
  local player = KMinimalistSafeApiObject.new(game.players[superadmin.extras.player_tools.player_name])

  for key, entity in pairs(player.surface.find_entities_filtered{position=player.position, radius=500, name="character-corpse"}) do
    local available_position = player.surface.find_non_colliding_position("character", entity.position, 20.0, 0.25)
    if available_position ~= nil then
      player.teleport(available_position)
    end
  end
end

FSACExtraPlayerTools.on_click_handler = function(event, superadmin)
  if superadmin.extras.player_tools == nil then
    return
  end
  local player = game.players[superadmin.extras.player_tools.player_name]
  if player == nil then
    return
  end

  if event.element.name == "ex_pt_kill" then
    if player.character ~= nil then
      player.character.die(player.force)
      FSACExtraPlayerTools.update_values(player)
    end
  elseif event.element.name == "ex_pt_kill_long" then
    if player.character ~= nil then
      player.character.die(player.force)
      FSACExtraPlayerTools.update_values(player)
    end
    player.ticks_to_respawn = 4294967294 -- max possible cooldown
  elseif event.element.name == "ex_pt_resurrect" then
    if player.character == nil then
      player.ticks_to_respawn = 1
    end
  elseif event.element.name == "ex_pt_give_armor" then
    FSACExtraPlayerTools.clear_armor(player)
    FSACExtraPlayerTools.give_op_armor(player)
  elseif event.element.name == "ex_pt_rm_armor" then
    FSACExtraPlayerTools.clear_armor(player)
  elseif event.element.name == "ex_pt_rm_all_armor" then
    FSACExtraPlayerTools.delete_all_armor(player)
  elseif event.element.name == "ex_pt_rm_all_armor" then
    FSACExtraPlayerTools.delete_all_armor(player)
  elseif event.element.name == "ex_pt_tp_p" then
    FSACExtraPlayerTools.teleport_to_player(superadmin)
  elseif event.element.name == "ex_pt_tp_l" then
    FSACExtraPlayerTools.teleport_to_position(superadmin)
  elseif event.element.name == "ex_pt_tp_o_pc" then
    FSACExtraPlayerTools.teleport_to_corpse(superadmin)
  end
end

FSACExtraPlayerTools.on_select_handler = function(event, superadmin)
  if superadmin.extras.player_tools == nil then
    return
  end

  if event.element.name == "ex_pt_dropdown" then
    superadmin.extras.player_tools.player_name = event.element.items[event.element.selected_index]
    FSACExtraPlayerTools.update_values(game.players[superadmin.extras.player_tools.player_name])
  elseif event.element.name == "ex_tp_p_dropdown" then
    superadmin.extras.player_tools.tp_player_name = event.element.items[event.element.selected_index]
  end
end

FSACExtraPlayerTools.on_checked_handler = function(event, superadmin)
  if superadmin.extras.player_tools == nil then
    return
  end
  local player = game.players[superadmin.extras.player_tools.player_name]
  if player == nil then
    return
  end

  if event.element.name == "ex_pt_cheat_checkbox" then
    player.cheat_mode = not player.cheat_mode
    FSACExtraPlayerTools.update_values(player)
  end
end

FSACExtraPlayerTools.on_value_handler = function(event, superadmin)
  if superadmin.extras.player_tools == nil then
    return
  end
  local player = game.players[superadmin.extras.player_tools.player_name]
  if player == nil then
    return
  end

  if player.character ~= nil then
    if event.element.name == "ex_pt_craft_slider" then
      player.character_crafting_speed_modifier = event.element.slider_value
      FSACExtraPlayerTools.update_values(player)
    elseif event.element.name == "ex_pt_mine_slider" then
      player.character_mining_speed_modifier = event.element.slider_value
      FSACExtraPlayerTools.update_values(player)
    elseif event.element.name == "ex_pt_run_slider" then
      player.character_running_speed_modifier = event.element.slider_value
      FSACExtraPlayerTools.update_values(player)
    end
  end
end



-- =======================================================================
-- ========================== EVENT LISTENING ============================
-- =======================================================================



FSACExtraPlayerTools.on_event_update = function(event)
  if event ~= nil then
    if event.player_index ~= nil then
      if game.players[event.player_index] ~= nil then
        FSACExtraPlayerTools.update_values(game.players[event.player_index])
      end
    end
  end
end

KMinimalistBootstrap.register(defines.events.on_player_joined_game, FSACExtraPlayerTools.on_event_update)
KMinimalistBootstrap.register(defines.events.on_player_left_game, FSACExtraPlayerTools.on_event_update)
KMinimalistBootstrap.register(defines.events.on_player_created, FSACExtraPlayerTools.on_event_update)
KMinimalistBootstrap.register(defines.events.on_player_driving_changed_state, FSACExtraPlayerTools.on_event_update)
KMinimalistBootstrap.register(defines.events.on_player_died, FSACExtraPlayerTools.on_event_update)
KMinimalistBootstrap.register(defines.events.on_player_respawned, FSACExtraPlayerTools.on_event_update)
KMinimalistBootstrap.register(defines.events.on_player_removed, FSACExtraPlayerTools.on_event_update)



-- =======================================================================
-- ============================= GUI SCRIPT ==============================
-- =======================================================================



FSACExtraPlayerTools.draw = function(frame, superadmin)
  if superadmin.extras.player_tools == nil then
    superadmin.extras.player_tools = {}
  end

  frame.add{type = "flow", name="ex_pt_flow_1", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_1, "fsac_extra_flow", { top_margin = 10})

  frame.ex_pt_flow_1.add{type = "label", name="ex_pt_select_label", caption = "[font=default-semibold]Select a player: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_1.ex_pt_select_label, "fsac_extra_label", { width_f = 332 })

  local players_names = FSACMainScript.get_player_names()
  frame.ex_pt_flow_1.add{type = "drop-down", name = "ex_pt_dropdown", selected_index = 1, items = players_names}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_1.ex_pt_dropdown, { width_f = 400 })

  superadmin.extras.player_tools.player_name = players_names[1]

  frame.add{type = "flow", name="ex_pt_flow_2", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_2, "fsac_extra_flow", { top_margin = 30})

  frame.ex_pt_flow_2.add{type = "label", name="ex_pt_cheat_label", caption = "[font=default-semibold]Enable cheat mode: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_2.ex_pt_cheat_label, "fsac_extra_label", { width_f = 712 })

  frame.ex_pt_flow_2.add{type = "checkbox", name="ex_pt_cheat_checkbox", caption = "", state = game.players[superadmin.extras.player_tools.player_name].cheat_mode}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_2.ex_pt_cheat_checkbox, { height_f = 20, width_f = 20, margin = 0 })

  frame.add{type = "flow", name="ex_pt_flow_3", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_3, "fsac_extra_flow")

  frame.ex_pt_flow_3.add{type = "label", name="ex_pt_kill_label", caption = "[font=default-semibold]Kill player: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_3.ex_pt_kill_label, "fsac_extra_label", { width_f = 454 })

  frame.ex_pt_flow_3.add{type = "button", name="ex_pt_kill", caption = "Kill", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_3.ex_pt_kill, "fsac_extra_btn")

  frame.ex_pt_flow_3.add{type = "button", name="ex_pt_kill_long", caption = "Kill Forever", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_3.ex_pt_kill_long, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_pt_flow_4", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_4, "fsac_extra_flow")

  frame.ex_pt_flow_4.add{type = "label", name="ex_pt_resurrect_label", caption = "[font=default-semibold]Resurrect player: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_4.ex_pt_resurrect_label, "fsac_extra_label", { width_f = 597 })

  frame.ex_pt_flow_4.add{type = "button", name="ex_pt_resurrect", caption = "Resurrect", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_4.ex_pt_resurrect, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_pt_flow_5", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_5, "fsac_extra_flow")

  frame.ex_pt_flow_5.add{type = "label", name="ex_pt_craft_label", caption = "[font=default-semibold]Crafting speed modifier: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_5.ex_pt_craft_label, "fsac_extra_label", { width_f = 332 })

  frame.ex_pt_flow_5.add{type = "slider", name="ex_pt_craft_slider", minimum_value = 0.0, maximum_value = 200.0, value = 1}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_5.ex_pt_craft_slider, { width_f = 400, margin = 0 })

  frame.add{type = "flow", name="ex_pt_flow_6", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_6, "fsac_extra_flow")

  frame.ex_pt_flow_6.add{type = "label", name="ex_pt_mine_label", caption = "[font=default-semibold]Mining speed modifier: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_6.ex_pt_mine_label, "fsac_extra_label", { width_f = 332 })

  frame.ex_pt_flow_6.add{type = "slider", name="ex_pt_mine_slider", minimum_value = 0.0, maximum_value = 100.0, value = 1}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_6.ex_pt_mine_slider, { width_f = 400, margin = 0 })

  frame.add{type = "flow", name="ex_pt_flow_7", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_7, "fsac_extra_flow")

  frame.ex_pt_flow_7.add{type = "label", name="ex_pt_run_label", caption = "[font=default-semibold]Running speed modifier: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_7.ex_pt_run_label, "fsac_extra_label", { width_f = 332 })

  frame.ex_pt_flow_7.add{type = "slider", name="ex_pt_run_slider", minimum_value = 0.0, maximum_value = 50.0, value = 1}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_7.ex_pt_run_slider, { width_f = 400, margin = 0 })

  frame.add{type = "flow", name="ex_pt_flow_8", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_8, "fsac_extra_flow")

  frame.ex_pt_flow_8.add{type = "label", name="ex_pt_eq_label", caption = "[font=default-semibold]Equipment manipulation: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_8.ex_pt_eq_label, "fsac_extra_label", { width_f = 311 })

  frame.ex_pt_flow_8.add{type = "button", name="ex_pt_give_armor", caption = "Give OP Armor", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_8.ex_pt_give_armor, "fsac_extra_btn")

  frame.ex_pt_flow_8.add{type = "button", name="ex_pt_rm_armor", caption = "Remove Armor", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_8.ex_pt_rm_armor, "fsac_extra_btn")

  frame.ex_pt_flow_8.add{type = "button", name="ex_pt_rm_all_armor", caption = "Remove All Armor", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_8.ex_pt_rm_all_armor, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_pt_flow_9", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_9, "fsac_extra_flow")

  frame.ex_pt_flow_9.add{type = "label", name="ex_pt_tp_p_label", caption = "[font=default-semibold]Teleport to player: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_9.ex_pt_tp_p_label, "fsac_extra_label", { width_f = 311 })

  frame.ex_pt_flow_9.add{type = "drop-down", name = "ex_tp_p_dropdown", selected_index = 1, items = players_names}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_9.ex_tp_p_dropdown, "fsac_extra_btn", { width_f = 278 })

  superadmin.extras.player_tools.tp_player_name = players_names[1]

  frame.ex_pt_flow_9.add{type = "button", name="ex_pt_tp_p", caption = "Teleport", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_9.ex_pt_tp_p, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_pt_flow_10", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_10, "fsac_extra_flow")

  frame.ex_pt_flow_10.add{type = "label", name="ex_pt_tp_l_label", caption = "[font=default-semibold]Teleport to location: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_10.ex_pt_tp_l_label, "fsac_extra_label", { width_f = 311 })

  frame.ex_pt_flow_10.add{type = "textfield", name = "x_pos_string"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_10.x_pos_string, "fsac_extra_string")

  frame.ex_pt_flow_10.add{type = "textfield", name = "y_pos_string"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_10.y_pos_string, "fsac_extra_string")

  frame.ex_pt_flow_10.add{type = "button", name="ex_pt_tp_l", caption = "Teleport", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_10.ex_pt_tp_l, "fsac_extra_btn")

  frame.add{type = "flow", name="ex_pt_flow_11", direction="horizontal"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_11, "fsac_extra_flow", { bottom_margin = 10 })

  frame.ex_pt_flow_11.add{type = "label", name="ex_pt_tp_o_label", caption = "[font=default-semibold]Other teleportation options: [/font]"}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_11.ex_pt_tp_o_label, "fsac_extra_label", { width_f = 597 })

  frame.ex_pt_flow_11.add{type = "button", name="ex_pt_tp_o_pc", caption = "To Player Corpse", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(frame.ex_pt_flow_11.ex_pt_tp_o_pc, "fsac_extra_btn")

  FSACExtraPlayerTools.update_values(game.players[superadmin.extras.player_tools.player_name])
end



-- =======================================================================
-- ============================ REGISTRATION =============================
-- =======================================================================



FSACExtra.static_register(
  "player_tools",
  "Player Tools",
  FSACExtraPlayerTools.draw,
  {
    on_click = FSACExtraPlayerTools.on_click_handler,
    on_selected = FSACExtraPlayerTools.on_select_handler,
    on_checked = FSACExtraPlayerTools.on_checked_handler,
    on_value = FSACExtraPlayerTools.on_value_handler
  }
)