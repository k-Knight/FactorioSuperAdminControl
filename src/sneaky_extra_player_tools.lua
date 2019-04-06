-- =======================================================================
-- ======================== EXTRA FUNCTIONALITY ==========================
-- =======================================================================
-- =========================== Player Tools ==============================
-- =======================================================================



function ex_pt_update_values(player)
  if player ~= nil then
    global.extras.player_tools.parent_frame.ex_pt_flow_2.ex_pt_cheat_checkbox.state = player.cheat_mode
    if player.character ~= nil then
      global.extras.player_tools.parent_frame.ex_pt_flow_5.ex_pt_craft_slider.slider_value = player.character_crafting_speed_modifier
      global.extras.player_tools.parent_frame.ex_pt_flow_6.ex_pt_mine_slider.slider_value = player.character_mining_speed_modifier
      global.extras.player_tools.parent_frame.ex_pt_flow_7.ex_pt_run_slider.slider_value = player.character_running_speed_modifier
    end
  end
end

function ex_pt_clear_armor(player)
  local p_armor = player.get_inventory(defines.inventory.player_armor)[1]
  if p_armor ~= nil then
    p_armor.clear()
  end
end

function ex_pt_delete_all_armor(player)
  ex_pt_clear_armor(player)
  player.get_main_inventory().remove({name="power-armor-mk2", count = 4294967294})
  player.get_main_inventory().remove({name="power-armor", count = 4294967294})
  player.get_main_inventory().remove({name="modular-armor", count = 4294967294})
  player.get_main_inventory().remove({name="heavy-armor", count = 4294967294})
  player.get_main_inventory().remove({name="light-armor", count = 4294967294})
end

function ex_pt_give_op_armor(player)
  player.insert{name="power-armor-mk2", count = 1}
  local p_armor = player.get_inventory(defines.inventory.player_armor)[1].grid
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

function extras_player_tools_on_click_handler(event)
  if global.extras.player_tools == nil then
    return
  end
  local player = game.players[global.extras.player_tools.player_name]
  if player == nil then
    return
  end

  if event.element.name == "ex_pt_kill" then
    if player.character ~= nil then
      player.character.die(player.force)
      ex_pt_update_values(player)
    end
  elseif event.element.name == "ex_pt_kill_long" then
    if player.character ~= nil then
      player.character.die(player.force)
      ex_pt_update_values(player)
    end
    player.ticks_to_respawn = 4294967294 -- max possible cooldown
  elseif event.element.name == "ex_pt_resurrect" then
    if player.character == nil then
      player.ticks_to_respawn = 1
    end
  elseif event.element.name == "ex_pt_give_armor" then
    ex_pt_clear_armor(player)
    ex_pt_give_op_armor(player)
  elseif event.element.name == "ex_pt_rm_armor" then
    ex_pt_clear_armor(player)
  elseif event.element.name == "ex_pt_rm_all_armor" then
    ex_pt_delete_all_armor(player)
  end
end

function extras_player_tools_on_select_handler(event)
  if global.extras.player_tools == nil then
    return
  end

  if event.element.name == "ex_pt_dropdown" then
    global.extras.player_tools.player_name = event.element.items[event.element.selected_index]
    ex_pt_update_values(game.players[global.extras.player_tools.player_name])
  end
end

function extras_player_tools_on_checked_handler(event)
  if global.extras.player_tools == nil then
    return
  end
  local player = game.players[global.extras.player_tools.player_name]
  if player == nil then
    return
  end

  if event.element.name == "ex_pt_cheat_checkbox" then
    player.cheat_mode = not player.cheat_mode
    global.extras.player_tools.parent_frame.ex_pt_flow_2.ex_pt_cheat_checkbox.state = player.cheat_mode
  end
end

function extras_player_tools_on_value_handler(event)
  if global.extras.player_tools == nil then
    return
  end
  local player = game.players[global.extras.player_tools.player_name]
  if player == nil then
    return
  end

  if player.character ~= nil then
    if event.element.name == "ex_pt_craft_slider" then
      player.character_crafting_speed_modifier = event.element.slider_value
    elseif event.element.name == "ex_pt_mine_slider" then
      player.character_mining_speed_modifier = event.element.slider_value
    elseif event.element.name == "ex_pt_run_slider" then
      player.character_running_speed_modifier = event.element.slider_value
    end
  end
end



-- =======================================================================
-- ============================= GUI SCRIPT ==============================
-- =======================================================================



function extras_player_tools_draw(frame)
  if global.extras.player_tools == nil then
    global.extras.player_tools = {}
  end
  global.extras.player_tools.parent_frame = frame

  frame.add{type = "flow", name="ex_pt_flow_1", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_1,
    {
      margin = {horizontal = 5, top = 10},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_1.add{type = "label", name="ex_pt_select_label", caption = "Select a player: "}
  apply_simple_style(
    frame.ex_pt_flow_1.ex_pt_select_label,
    {
      size = {width = 332},
      padding = 0,
      margin = 0
    }
  )

  local players_names = get_player_names()
  frame.ex_pt_flow_1.add{type = "drop-down", name = "ex_pt_dropdown", selected_index = 1, items = players_names}
  apply_simple_style(
    frame.ex_pt_flow_1.ex_pt_dropdown,
    {size = {width = 400}}
  )
  global.extras.player_tools.player_name = players_names[1]

  frame.add{type = "flow", name="ex_pt_flow_2", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_2,
    {
      margin = {horizontal = 5, top = 30},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_2.add{type = "label", name="ex_pt_cheat_label", caption = "Enable cheat mode: "}
  apply_simple_style(
    frame.ex_pt_flow_2.ex_pt_cheat_label,
    {
      size = {width = 712},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_2.add{type = "checkbox", name="ex_pt_cheat_checkbox", caption = "", state = game.players[global.extras.player_tools.player_name].cheat_mode}
  apply_simple_style(
    frame.ex_pt_flow_2.ex_pt_cheat_checkbox,
    {
      size = {height = 20, width = 20},
      margin = 0
    }
  )

  frame.add{type = "flow", name="ex_pt_flow_3", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_3,
    {
      margin = {horizontal = 5, top = 5},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_3.add{type = "label", name="ex_pt_kill_label", caption = "Kill player: "}
  apply_simple_style(
    frame.ex_pt_flow_3.ex_pt_kill_label,
    {
      size = {width = 454},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_3.add{type = "button", name="ex_pt_kill", caption = "Kill", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_pt_flow_3.ex_pt_kill,
    {
      size = {width = 135},
      margin = 0
    }
  )
  frame.ex_pt_flow_3.add{type = "button", name="ex_pt_kill_long", caption = "Kill Forever", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_pt_flow_3.ex_pt_kill_long,
    {
      size = {width = 135},
      margin = 0
    }
  )

  frame.add{type = "flow", name="ex_pt_flow_4", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_4,
    {
      margin = {horizontal = 5, top = 5},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_4.add{type = "label", name="ex_pt_resurrect_label", caption = "Resurrect player: "}
  apply_simple_style(
    frame.ex_pt_flow_4.ex_pt_resurrect_label,
    {
      size = {width = 597},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_4.add{type = "button", name="ex_pt_resurrect", caption = "Resurrect", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_pt_flow_4.ex_pt_resurrect,
    {
      size = {width = 135},
      margin = 0
    }
  )

  frame.add{type = "flow", name="ex_pt_flow_5", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_5,
    {
      margin = {horizontal = 5, top = 5},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_5.add{type = "label", name="ex_pt_craft_label", caption = "Crafting speed modifier: "}
  apply_simple_style(
    frame.ex_pt_flow_5.ex_pt_craft_label,
    {
      size = {width = 332},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_5.add{type = "slider", name="ex_pt_craft_slider", minimum_value = 0.0, maximum_value = 200.0, value = game.players[global.extras.player_tools.player_name].character_crafting_speed_modifier}
  apply_simple_style(
    frame.ex_pt_flow_5.ex_pt_craft_slider,
    {
      size = {width = 400},
      margin = 0
    }
  )

  frame.add{type = "flow", name="ex_pt_flow_6", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_6,
    {
      margin = {horizontal = 5, top = 5},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_6.add{type = "label", name="ex_pt_mine_label", caption = "Mining speed modifier: "}
  apply_simple_style(
    frame.ex_pt_flow_6.ex_pt_mine_label,
    {
      size = {width = 332},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_6.add{type = "slider", name="ex_pt_mine_slider", minimum_value = 0.0, maximum_value = 100.0, value = game.players[global.extras.player_tools.player_name].character_mining_speed_modifier}
  apply_simple_style(
    frame.ex_pt_flow_6.ex_pt_mine_slider,
    {
      size = {width = 400},
      margin = 0
    }
  )

  frame.add{type = "flow", name="ex_pt_flow_7", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_7,
    {
      margin = {horizontal = 5, top = 5},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_7.add{type = "label", name="ex_pt_run_label", caption = "Running speed modifier: "}
  apply_simple_style(
    frame.ex_pt_flow_7.ex_pt_run_label,
    {
      size = {width = 332},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_7.add{type = "slider", name="ex_pt_run_slider", minimum_value = 0.0, maximum_value = 50.0, value = game.players[global.extras.player_tools.player_name].character_running_speed_modifier}
  apply_simple_style(
    frame.ex_pt_flow_7.ex_pt_run_slider,
    {
      size = {width = 400},
      margin = 0
    }
  )

  frame.add{type = "flow", name="ex_pt_flow_8", direction="horizontal"}
  apply_simple_style(
    frame.ex_pt_flow_8,
    {
      margin = {horizontal = 5, top = 5, bottom = 10},
      spacing = {horizontal = 8}
    }
  )

  frame.ex_pt_flow_8.add{type = "label", name="ex_pt_eq_label", caption = "Equipment manipulation: "}
  apply_simple_style(
    frame.ex_pt_flow_8.ex_pt_eq_label,
    {
      size = {width = 311},
      padding = 0,
      margin = 0
    }
  )
  frame.ex_pt_flow_8.add{type = "button", name="ex_pt_give_armor", caption = "Give OP Armor", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_pt_flow_8.ex_pt_give_armor,
    {
      size = {width = 135},
      margin = 0
    }
  )
  frame.ex_pt_flow_8.add{type = "button", name="ex_pt_rm_armor", caption = "Remove Armor", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_pt_flow_8.ex_pt_rm_armor,
    {
      size = {width = 135},
      margin = 0
    }
  )
  frame.ex_pt_flow_8.add{type = "button", name="ex_pt_rm_all_armor", caption = "Remove All Armor", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.ex_pt_flow_8.ex_pt_rm_all_armor,
    {
      size = {width = 135},
      margin = 0
    }
  )
end