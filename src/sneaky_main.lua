-- =======================================================================
-- ======================= For  Factorio 0.17.20 =========================
-- =======================================================================
-- ==================== SNEAKY SCRIPT INITIALIATION ======================
-- =======================================================================



require("./sneaky_styling.lua") -- functions: apply_simple_style
require("./sneaky_nyan.lua") -- nyan character color functionality
require("./sneaky_execute.lua") -- execute menu functionality
require("./sneaky_gmspd.lua") -- game speed menu functionality
require("./sneaky_extra.lua") -- extras menu functionality



function init_mod()
  global.player_name = "YOUR_NAME_HERE"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!
  global.menu_enabled = false

  global.nyan = {}
  global.nyan.player_name = ""

  global.command_string = ""
  global.game_speed = 1.0

  global.extras = {}
  global.extras.functionality = {}
end

-- ========================== FOR DEVELOPERS ===============================
--                    ===== Interface Desction =====
--  function (from ./sneaky_extra.lua):
--      register_extra_functionality(button_caption, draw_function, handlers)
--
--      description:
--          adds additional functionality to the sneaky script
--      arguments:
--          button_caption: the name of the button (that is displayed to the user)
--          draw_function: draw function of your functionality
--              as an argument should take a frame LuaGuiElement (https://lua-api.factorio.com/latest/LuaGuiElement.html)
--          handlers: table with handlers for gui events, has following elements:
--              on_click: handler function, takes event arguments of on_gui_click event
--              on_checked: handler function, takes event arguments of on_gui_checked_state_changed event
--              on_selected: handler function, takes event arguments of on_gui_selection_state_changed event
--              on_value: handler function, takes event arguments of on_gui_value_changed event
--
--        for reference on factorio api events: https://lua-api.factorio.com/latest/events.html



-- =======================================================================
-- =========================== SNEAKY SCRIPT =============================
-- =======================================================================



function get_player_names()
  names = {}

  for _, player in pairs(game.players) do
    names[#names + 1] = player.name
  end

  return names
end

function on_tick_handler(event)
  if global.nyan == nil then
    init_mod()
    if game.players[global.player_name] ~= nil then
      draw_sneaky_gui()
    end
  end

  local color = HUEtoRGB((game.tick % 180) * 2)

  for index, player in pairs(game.players) do
    if global.nyan[tostring(player.name)] == nil then
      global.nyan[tostring(player.name)] = get_blank_color_history()
    end
    if global.nyan[tostring(player.name)].enabled == true then
      player.color = {r = color.r, g = color.g, b = color.b, a = 0.9}
    end
  end
end

function on_gui_checked_state_changed_handler(event)
  if global.player_name == nil then
    init_mod()
  end

  if game.players[global.player_name] ~= nil then
    if event.player_index == game.players[global.player_name].index then
      if event.element.name == "enable_sneaky" then
        if game.players[global.player_name].gui.top.sneaky_frame == nil then
          global.menu_enabled = true
        else
          global.menu_enabled = false
        end
        draw_sneaky_gui()
      end
    end
  end

  -- handler for extra funtionality
  extras_on_gui_checked_state_changed_handler(event)
end

function on_gui_click_handler(event)
  if global.player_name == nil then
    init_mod()
  end

  if event.player_index == game.players[global.player_name].index then
    draw_gui_if_absent()

    nyan_on_click_handler(event)
    execute_on_click_handler(event)
    gmspd_on_click_handler(event)
    extras_on_gui_click_handler(event)
  end
end

function on_player_joined_game_handler(event)
  if global.player_name == nil then
    init_mod()
  end

  if game.players[global.player_name] ~= nil then
    draw_gui_if_absent()
  end
end

function on_player_left_game_handler(event)
  if global.player_name == nil then
    init_mod()
  end

  end_nyan(game.players[event.player_index].name)
end

function on_gui_selection_state_changed_handler(event)
  if global.player_name == nil then
    init_mod()
  end

  if event.player_index == game.players[global.player_name].index then
    draw_gui_if_absent()

    -- nyan player select
    if (event.element.name == "nyan_player_drop_down") then
      global.nyan.player_name = event.element.items[event.element.selected_index]
    end

    -- handler for extra funtionality
    extras_on_gui_selection_state_changed_handler(event)
  end
end

function on_gui_value_changed_handler(event)
  if global.player_name == nil then
    init_mod()
  end

  if event.player_index == game.players[global.player_name].index then
    draw_gui_if_absent()

    -- game speed slider
    if (event.element.name == "gmspd_slider") then
      event.element.slider_value = math.floor(event.element.slider_value * 10.0) / 10.0
      change_game_speed(event.element.slider_value)
    end

    -- handler for extra funtionality
    extras_on_gui_value_changed_handler(event)
  end
end

function ugly_force_register(event, handler)
  local old_handler = script.get_event_handler(event)

  if old_handler ~= nil then
    script.on_event(event, function(e)
      old_handler(e)
      handler(e)
    end)
  else
    script.on_event(event, handler)
  end
end

script.on_nth_tick(6, on_tick_handler)
ugly_force_register(defines.events.on_gui_checked_state_changed, on_gui_checked_state_changed_handler)
ugly_force_register(defines.events.on_gui_click, on_gui_click_handler)
ugly_force_register(defines.events.on_player_joined_game, on_player_joined_game_handler)
ugly_force_register(defines.events.on_player_left_game, on_player_left_game_handler)
ugly_force_register(defines.events.on_gui_selection_state_changed, on_gui_selection_state_changed_handler)
ugly_force_register(defines.events.on_gui_value_changed, on_gui_value_changed_handler)



-- =======================================================================
-- ========================= SNEAKY GIU SCRIPT ===========================
-- =======================================================================



function draw_gui_if_absent()
  if game.players[global.player_name].gui.top.sneaky_frame == nil and game.players[global.player_name].gui.top.enable_sneaky == nil then
    draw_sneaky_gui()
  end
end

function draw_sneaky_gui()
  local player = game.players[global.player_name]

  destroy_sneaky_gui(player)

  if global.menu_enabled == true then
    draw_gui_frame(player)
  else
    -- draw sneaky checkbox
    player.gui.top.add{type = "checkbox", name="enable_sneaky", state = false}
    apply_simple_style(
      player.gui.top.enable_sneaky,
      {margin = {top = 5}}
    )
  end
end

function destroy_sneaky_gui(player)
  if player.gui.top.enable_sneaky ~= nil then
    player.gui.top.enable_sneaky.destroy()
  end
  if player.gui.top.sneaky_frame ~= nil then
    close_additional_menu()
    player.gui.top.sneaky_frame.destroy()
  end
end

function draw_gui_frame(player)
  player.gui.top.add{type = "frame", caption = "Sneaky Menu", name = "sneaky_frame", direction = "vertical"}
  local sneaky_fame = player.gui.top.sneaky_frame
  apply_simple_style(
    sneaky_fame,
    {
      padding = 5,
      margin = {right = 5, left = -1, vertical = 5}
    }
  )
  sneaky_fame.add{type = "checkbox", name="enable_sneaky", caption = "show menu", state = true}
  apply_simple_style(
    sneaky_fame.enable_sneaky,
    {margin = {left = 3, vertical = 5}}
  )

  draw_nyan_gui(sneaky_fame)
  draw_execute_gui(sneaky_fame)
  draw_game_speed_gui(sneaky_fame)
  draw_extras_btn_gui(sneaky_fame)
end