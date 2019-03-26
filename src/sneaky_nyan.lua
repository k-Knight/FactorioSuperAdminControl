function get_blank_color_history()
  local table = {}

  table.r = 0
  table.g = 0
  table.b = 0
  table.a = 0
  table.enabled = false

  return table
end

function end_nyan(name)
  local color_record = global.nyan[tostring(name)]
  color_record.enabled = false

  if game.players[name] ~= nil then
    game.players[name].color={r = color_record.r, g = color_record.g, b = color_record.b, a = color_record.a}
  end
end

function start_nyan(name)
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

function HUEtoRGB(hue)
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

function nyan_on_click_handler(event)
  -- start nyan
  if event.element.name == "start_nyan" then
    start_nyan(global.nyan.player_name)
  -- end nyan
  elseif event.element.name == "end_nyan" then
    end_nyan(global.nyan.player_name)
  end
end

-- ============================ GUI SCRIPT =============================

function draw_nyan_gui(frame)
  frame.add{type = "frame", caption = "Rainbow Color", name = "nyan_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  apply_simple_style(
    frame.nyan_frame,
    {
      padding = 10,
      margin = {bottom = 5}
    }
  )

  frame.nyan_frame.add{type = "table", name = "nyan_table1", column_count = 1}
  frame.nyan_frame.nyan_table1.add{type = "table", name = "nyan_table1_1", column_count = 1}
  frame.nyan_frame.nyan_table1.add{type = "table", name = "nyan_table1_2", column_count = 2}
  apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_2,
    {margin = {top = 5}}
  )

  local players_names = get_player_names()
  frame.nyan_frame.nyan_table1.nyan_table1_1.add{type = "drop-down", name = "nyan_player_drop_down", selected_index = 1, items = players_names}
  apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_1.nyan_player_drop_down,
    {size = {width = 203}}
  )
  global.nyan.player_name = players_names[1]

  frame.nyan_frame.nyan_table1.nyan_table1_2.add{type = "button", name="start_nyan", caption = "Start", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_2.start_nyan,
    {
      size = {width = 95},
      margin = {right = 9}
    }
  )
  frame.nyan_frame.nyan_table1.nyan_table1_2.add{type = "button", name="end_nyan", caption = "Stop", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.nyan_frame.nyan_table1.nyan_table1_2.end_nyan,
    {size = {width = 95}}
  )
end