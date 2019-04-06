function sneaky_execute(string)
  if not pcall(loadstring(string)) then
    game.players[global.player_name].print("[SILENT]: command failed to execute (error message is not provided because of a possible desync)")
  end
end

function execute_on_click_handler(event)
  if event.element.name == "sneaky_enter" then
    if game.players[global.player_name].gui.top.sneaky_frame.cheesy_frame.sneaky_string.text ~= nil then
      global.command_string = game.players[global.player_name].gui.top.sneaky_frame.cheesy_frame.sneaky_string.text
      sneaky_execute(global.command_string)
    end
  end
end

-- ============================ GUI SCRIPT =============================

function draw_execute_gui(frame, command_string)
  frame.add{type = "frame", caption = "Execute Menu", name = "cheesy_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  apply_simple_style(
    frame.cheesy_frame,
    {
      padding = 10,
      margin = {bottom = 5}
    }
  )

  frame.cheesy_frame.add{type = "textfield", name = "sneaky_string"}
  apply_simple_style(
    frame.cheesy_frame.sneaky_string,
    {size = {width = 200}}
  )
  frame.cheesy_frame.add{type = "button", name = "sneaky_enter", caption = "Enter", mouse_button_filter = {"left"}}
  apply_simple_style(
    frame.cheesy_frame.sneaky_enter,
    {
      size = {width = 200},
      padding = {right = 2, left = 3},
      margin = {top = 5}
    }
  )

  frame.cheesy_frame.sneaky_string.text = global.command_string
end