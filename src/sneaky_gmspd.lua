function change_game_speed(speed)
  if speed < 0.0167 then
    speed = 0.0167
  end
  if speed > 100 then
    speed = 100
  end

  global.game_speed = speed
  game.players[global.player_name].gui.top.sneaky_frame.game_speed_frame.gmspd_table1.gmspd_table1_1.game_speed_field.text = tostring(global.game_speed)
  game.players[global.player_name].gui.top.sneaky_frame.game_speed_frame.gmspd_table1.gmspd_slider.slider_value = global.game_speed
  game.speed = global.game_speed
end

function gmspd_on_click_handler(event)
  if event.element.name == "gmspd_ss" then
    change_game_speed(global.game_speed - 1.0)
  elseif event.element.name == "gmspd_s" then
    change_game_speed(global.game_speed - 0.1)
  elseif event.element.name == "gmspd_f" then
    change_game_speed(global.game_speed + 0.1)
  elseif event.element.name == "gmspd_ff" then
    change_game_speed(global.game_speed + 1.0)
  elseif event.element.name == "set_game_speed" then
    local speed = tonumber(game.players[global.player_name].gui.top.sneaky_frame.game_speed_frame.gmspd_table1.gmspd_table1_1.game_speed_field.text)
    if speed ~= nil then
      change_game_speed(speed)
    else
      game.players[global.player_name].print("[SILENT]: failed to understand the number")
    end
  elseif event.element.name == "reset_game_speed" then
    change_game_speed(1.0)
  end
end

-- ============================ GUI SCRIPT =============================

function draw_game_speed_gui(frame)
  global.game_speed = game.speed

  frame.add{type = "frame", caption = "Game Speed", name = "game_speed_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  apply_simple_style(
    frame.game_speed_frame,
    {padding = 10}
  )
  frame.game_speed_frame.add{type = "table", name = "gmspd_table1", column_count = 1}
  frame.game_speed_frame.gmspd_table1.add{type = "table", name = "gmspd_table1_1", column_count = 5}
  frame.game_speed_frame.gmspd_table1.add{type = "slider", name = "gmspd_slider", minimum_value = 0.1, maximum_value = 10, value = global.game_speed}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_slider,
    {
      size = {width = 203},
      margin = {vertical = 5}
    }
  )
  frame.game_speed_frame.gmspd_table1.add{type = "table", name = "gmspd_table1_2", column_count = 2}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_2,
    {margin = {top = 5}}
  )

  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_ss", caption = "<<", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_ss,
    {
      size = {width = 30},
      padding = {horizontal = 2}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_s", caption = "<", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_s,
    {
      size = {width = 25},
      padding = {horizontal = 2}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "textfield", name = "game_speed_field", text = tostring(global.game_speed)}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.game_speed_field,
    {size = {width = 77}}
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_f", caption = ">", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_f,
    {
      size = {width = 25},
      padding = {horizontal = 2}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_ff", caption = ">>", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_ff,
    {
      size = {width = 30},
      padding = {horizontal = 2}
    }
  )

  frame.game_speed_frame.gmspd_table1.gmspd_table1_2.add{type = "button", name="set_game_speed", caption = "Set", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_2.set_game_speed,
    {
      size = {width = 95},
      margin = {right = 9}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_2.add{type = "button", name="reset_game_speed", caption = "Reset", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_2.reset_game_speed,
    {size ={width = 95}}
  )
end