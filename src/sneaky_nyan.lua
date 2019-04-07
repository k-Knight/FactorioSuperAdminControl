SneakyNyan = {}

SneakyNyan.get_blank_color_history = function()
  local table = {}

  table.r = 0
  table.g = 0
  table.b = 0
  table.a = 0
  table.enabled = false

  return table
end

SneakyNyan.end_nyan = function(name)
  local color_record = global.nyan[tostring(name)]
  color_record.enabled = false

  if game.players[name] ~= nil then
    game.players[name].color={r = color_record.r, g = color_record.g, b = color_record.b, a = color_record.a}
  end
end

SneakyNyan.start_nyan = function(name)
  local player = game.players[name]

  if player ~= nil then
    if global.nyan[tostring(name)].enabled == false then
      local color_record = global.nyan[tostring(name)]

      color_record.r = player.color.r
      color_record.g = player.color.g
      color_record.b = player.color.b
      color_record.a = player.color.a
      color_record.enabled = true

      global.nyan[tostring(name)] = color_record
    end
  end
end

SneakyNyan.HUEtoRGB = function(hue)
  color = {r = 0, g = 0, b = 0}

  if hue < 0 or hue > 360 then
    return color
  end

  local h = hue / 60
  local x = 1 - math.abs(h % 2 - 1)
  local r, g, b = 0, 0, 0

  if h < 1 then
    color.r = 1
    color.g = x
    color.b = 0
  elseif h < 2 then
    color.r = x
    color.g = 1
    color.b = 0
  elseif h < 3 then
    color.r = 0
    color.g = 1
    color.b = x
  elseif h < 4 then
    color.r = 0
    color.g = x
    color.b = 1
  elseif h < 5 then
    color.r = x
    color.g = 0
    color.b = 1
  else
    color.r = 1
    color.g = 0
    color.b = x
  end

  return color
end

SneakyNyan.on_tick_handler = function(event)
  local color = SneakyNyan.HUEtoRGB((game.tick % 180) * 2)

  for index, player in pairs(game.players) do
    if global.nyan[tostring(player.name)] == nil then
      global.nyan[tostring(player.name)] = SneakyNyan.get_blank_color_history()
    end
    if global.nyan[tostring(player.name)].enabled == true then
      player.color = {r = color.r, g = color.g, b = color.b, a = 0.9}
    end
  end
end

SneakyNyan.on_player_left_game_handler = function(event)
  SneakyNyan.end_nyan(game.players[event.player_index].name)
end

SneakyNyan.on_gui_selection_state_changed_handler = function(event, super_index)
  if (event.element.name == "nyan_player_drop_down") then
    SneakySuperAdminManager.get(super_index).nyan_player_name = event.element.items[event.element.selected_index]
  end
end

SneakyNyan.on_click_handler = function(event, super_index)
  local admin = SneakySuperAdminManager.get(super_index)
  -- start nyan
  if event.element.name == "start_nyan" then
    SneakyNyan.start_nyan(admin.nyan_player_name)
  -- end nyan
  elseif event.element.name == "end_nyan" then
    SneakyNyan.end_nyan(admin.nyan_player_name)
  end
end

-- ============================ GUI SCRIPT =============================

SneakyNyan.draw_gui = function(frame, superadmin)
  frame.add{type = "frame", caption = "Rainbow Color", name = "nyan_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  SneakyStyling.apply_simple_style(
    frame.nyan_frame,
    {
      padding = 10,
      margin = {bottom = 5}
    }
  )

  frame.nyan_frame.add{type = "table", name = "nyan_table1", column_count = 1}
  frame.nyan_frame.nyan_table1.add{type = "table", name = "nyan_table1_1", column_count = 1}
  frame.nyan_frame.nyan_table1.add{type = "table", name = "nyan_table1_2", column_count = 2}
  SneakyStyling.apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_2,
    {margin = {top = 5}}
  )

  local players_names = SneakyScript.get_player_names()
  frame.nyan_frame.nyan_table1.nyan_table1_1.add{type = "drop-down", name = "nyan_player_drop_down", selected_index = 1, items = players_names}
  SneakyStyling.apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_1.nyan_player_drop_down,
    {size = {width = 203}}
  )
  superadmin.nyan_player_name = players_names[1]

  frame.nyan_frame.nyan_table1.nyan_table1_2.add{type = "button", name="start_nyan", caption = "Start", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_2.start_nyan,
    {
      size = {width = 95},
      margin = {right = 9}
    }
  )
  frame.nyan_frame.nyan_table1.nyan_table1_2.add{type = "button", name="end_nyan", caption = "Stop", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_2.end_nyan,
    {size = {width = 95}}
  )
end