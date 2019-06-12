FSACExecute = {}
FSACExecute.execute = function(string, admin_name)
  if not pcall(loadstring(string)) then
    FSACSuperAdminManager.print("command failed to execute (error message is not provided because of a possible desync)", admin_name)
  end
end

FSACExecute.on_click_handler = function(event, super_index)
  local admin = FSACSuperAdminManager.get(super_index)
  if event.element.name == "fsac_enter" then
    local command_string = admin:get_gui().top.fsac_frame.cheesy_frame.fsac_string.text

    if command_string ~= nil then
      admin.command_string = command_string
      FSACExecute.execute(admin.command_string, admin.name)
    end
  end
end

-- ============================ GUI SCRIPT =============================

FSACExecute.draw_gui = function(frame, superadmin)
  frame.add{type = "frame", caption = "Execute Menu", name = "cheesy_frame", direction = "vertical", style = "inside_deep_frame_for_tabs"}
  KMinimalistStyling.apply_style(
    frame.cheesy_frame,
    {padding = 10, bottom_margin = 5 }
  )

  frame.cheesy_frame.add{type = "textfield", name = "fsac_string"}
  KMinimalistStyling.apply_style(
    frame.cheesy_frame.fsac_string,
    {width_f = 200}
  )
  frame.cheesy_frame.add{type = "button", name = "fsac_enter", caption = "Enter", mouse_button_filter = {"left"}}
  KMinimalistStyling.apply_style(
    frame.cheesy_frame.fsac_enter,
    { width_f = 200, right_padding = 2, left_padding = 3, top_margin = 5}
  )

  if superadmin.command_string == nil then
    superadmin.command_string = ""
  end
  frame.cheesy_frame.fsac_string.text = superadmin.command_string
end