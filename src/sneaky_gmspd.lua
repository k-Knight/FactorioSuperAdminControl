SneakyGameSpeed = {}
SneakyGameSpeed.change_speed = function(speed)
  if speed < 0.0167 then
    speed = 0.0167
  end
  if speed > 100 then
    speed = 100
  end

  global.game_speed = speed
  for _, admin in ipairs(SneakySuperAdminManager.get_all()) do
    local admin_gui = admin:get_gui()

    if admin_gui ~= nil then
      admin_gui.top.sneaky_frame.game_speed_frame.gmspd_table1.gmspd_table1_1.game_speed_field.text = tostring(global.game_speed)
      admin_gui.top.sneaky_frame.game_speed_frame.gmspd_table1.gmspd_slider.slider_value = global.game_speed
    end
  end
  game.speed = global.game_speed
end

SneakyGameSpeed.on_gui_value_changed_handler = function(event, super_index)
  if (event.element.name == "gmspd_slider") then
    event.element.slider_value = math.floor(event.element.slider_value * 10.0) / 10.0
    SneakyGameSpeed.change_speed(event.element.slider_value)
  end
end

SneakyGameSpeed.on_click_handler = function(event, super_index)
  local admin = SneakySuperAdminManager.get(super_index)

  if event.element.name == "gmspd_ss" then
    SneakyGameSpeed.change_speed(global.game_speed - 1.0)
  elseif event.element.name == "gmspd_s" then
    SneakyGameSpeed.change_speed(global.game_speed - 0.1)
  elseif event.element.name == "gmspd_f" then
    SneakyGameSpeed.change_speed(global.game_speed + 0.1)
  elseif event.element.name == "gmspd_ff" then
    SneakyGameSpeed.change_speed(global.game_speed + 1.0)
  elseif event.element.name == "set_game_speed" then
    local speed = tonumber(admin:get_gui().top.sneaky_frame.game_speed_frame.gmspd_table1.gmspd_table1_1.game_speed_field.text)
    if speed ~= nil then
      SneakyGameSpeed.change_speed(speed)
    else
      SneakySuperAdminManager.print("failed to understand the game speed number", admin.name)
    end
  elseif event.element.name == "reset_game_speed" then
    SneakyGameSpeed.change_speed(1.0)
  end
end

-- ============================ GUI SCRIPT =============================

SneakyGameSpeed.draw_gui = function(frame, superadmin)
  global.game_speed = game.speed

  frame.add{type = "frame", caption = "Game Speed", name = "game_speed_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame,
    {padding = 10}
  )
  frame.game_speed_frame.add{type = "table", name = "gmspd_table1", column_count = 1}
  frame.game_speed_frame.gmspd_table1.add{type = "table", name = "gmspd_table1_1", column_count = 5}
  frame.game_speed_frame.gmspd_table1.add{type = "slider", name = "gmspd_slider", minimum_value = 0.1, maximum_value = 10, value = global.game_speed}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_slider,
    {
      size = {width = 203},
      margin = {vertical = 5}
    }
  )
  frame.game_speed_frame.gmspd_table1.add{type = "table", name = "gmspd_table1_2", column_count = 2}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_2,
    {margin = {top = 5}}
  )

  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_ss", caption = "<<", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_ss,
    {
      size = {width = 30},
      padding = {horizontal = 2}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_s", caption = "<", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_s,
    {
      size = {width = 25},
      padding = {horizontal = 2}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "textfield", name = "game_speed_field", text = tostring(global.game_speed)}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.game_speed_field,
    {size = {width = 77}}
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_f", caption = ">", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_f,
    {
      size = {width = 25},
      padding = {horizontal = 2}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_1.add{type = "button", name = "gmspd_ff", caption = ">>", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_1.gmspd_ff,
    {
      size = {width = 30},
      padding = {horizontal = 2}
    }
  )

  frame.game_speed_frame.gmspd_table1.gmspd_table1_2.add{type = "button", name="set_game_speed", caption = "Set", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_2.set_game_speed,
    {
      size = {width = 95},
      margin = {right = 9}
    }
  )
  frame.game_speed_frame.gmspd_table1.gmspd_table1_2.add{type = "button", name="reset_game_speed", caption = "Reset", mouse_button_filter = {"left"}}
  SneakyStyling.apply_simple_style(
    frame.game_speed_frame.gmspd_table1.gmspd_table1_2.reset_game_speed,
    {size ={width = 95}}
  )
end