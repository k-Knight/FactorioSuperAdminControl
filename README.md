# FactorioSuperAdminControl
A script for the game Factorio that provides administrative and other functionality through the GUI. The offered functionality is quite powerful and influence the game to a significant degree.

## What this script features

1. Select players that will shimmer with rainbow colors.
2. Execute **Lua** scripts.
3. Manipulate game speed.
4. Promote and demote players to admin status.
5. Suppress console and chat for everyone, except for you.
6. Kill (including forever) or resurrect players.
7. Manipulate different characteristics of the players.
8. Manipulate equipment of players.
9. Promote other players to ***super-admin*** status.

## How to install a script

The script files include a default **``control.lua``** file if you want to inject a script into your **existing save** or you want to **play with achievements enabled**. Just copy all the script files (``control.lua``, folder ``kminimalist`` and folder ``fsac``) into the save archive.

Otherwise, if you want to attach this script your custom **``control.lua``** script, just be make sure to require **``fsac_main.lua``** at the end of your script.

## Configuring the script

To configure a script you just have to open **``fsac/fsac_main.lua``** file and change the following line (*you have to enter your name for script to recognize you as core super-admin*):
```lua
global.player_name = "YOUR_NAME_HERE"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!
 ```

# FSAC Reference

The script supports  adding new modules with different functionality for every super-admin (done statically) or for individual both during runtime and during the control stage of the game.

The script makes use of the **[kminimalist library](https://github.com/k-Knight/kminimalist)** for handling event registrations, GUI element styling during runtime and manipulating Factorio API tables without numerous checks and conditions.

## Adding extra modules during the control stage

To register extra functionality during the control stage 3 following steps need to be done.

1. Create your script and place it in ``fsac/extra/`` folder.
2. At the end of your script file make a call to [``FSACExtra.static_register``](#function-fsacextrastatic_registername-button_caption-draw_function-handlers) function with the appropriate arguments.
3. As **Lua** language does not support including script files, it is necessary to add a ``require(path_to_your_file)`` statement in the ``fsac/fsac_main.lua`` file **AFTER** the ``require`` statement for ``fsac_extra.lua`` file.
   ```lua
   require("./fsac_extra.lua") -- extra menu functionality

   require("./extra/your_module_name.lua")
   ```

### Function ``FSACExtra.static_register(name, button_caption, draw_function, handlers)``

This function adds the registration of additional functionality to all super-admins. It should be noted that this function **MUST NOT** be called during the runtime of the game and only during the control stage because of possible desyncs.

* **``name``** – ***string*** the unique identifier of the additional module
* **``button_caption``** – ***string*** the caption of the button that will be displayed in extra functionality menu (*readable name of the additional module*)
* **``draw_function``** – ***function*** the draw function of additional module as an argument should take a frame [**``LuaGuiElement``**](https://lua-api.factorio.com/latest/LuaGuiElement.html) and a [super-admin table](#super-admin-table) of a player for which the GUI is being drawn
* **``handlers``** – ***table*** with handlers for GUI events, **each handler** takes corresponding event arguments in a table as a **first argument** and a **[super-admin table](#super-admin-table)** of a player who triggered the event as a **second argument**, has the following elements:
  + **``on_click``** – ***function*** handler for [**``on_gui_click``**](https://lua-api.factorio.com/latest/events.html#on_gui_click) event
  + **``on_checked``** – ***function*** handler for  [**``on_gui_checked_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_checked_state_changed) event
  + **``on_selected``** – ***function*** handler for [**``on_gui_selection_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_selection_state_changed) event
  + **``on_value``** – ***function*** handler for [**``on_gui_value_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_value_changed) event


## Adding extra modules during the runtime

The script supports also registration of additional functionality during runtime. The registration needs to be done by calling the ``FSACExtra.register_functionality`` function with the appropriate arguments.

This can be viewed as a more personalized approach for registering functionality as the functionality can get added to the only super-admin provided in the ``admin`` argument of aforementioned function. It should be mentioned that any function of the additional module that is not provided in the function arguments **must be saved** to the ``global`` table of the game to persist through the save / load cycle.

### Function ``FSACExtra.register_functionality(name, button_caption, draw_function, handlers, admin)``

As described above, this function registers additional module to a specific super-admin. This function **DOES NOT** work during the control stage of the game.

**Return value:** a ***boolean*** value that is ``true`` in case of a successful registration.

* **``name``** – ***string*** the unique identifier of the additional module
* **``button_caption``** – ***string*** the caption of the button that will be displayed in extra functionality menu (*readable name of the additional module*)
* **``draw_function``** – ***function*** the draw function of additional module as an argument should take a frame [**``LuaGuiElement``**](https://lua-api.factorio.com/latest/LuaGuiElement.html) and a [super-admin table](#super-admin-table) of a player for which the GUI is being drawn
* **``handlers``** – ***table*** with handlers for GUI events, **each handler** takes corresponding event arguments in a table as a **first argument** and a **[super-admin table](#super-admin-table)** of a player who triggered the event as a **second argument**, has the following elements:
  + **``on_click``** – ***function*** handler for [**``on_gui_click``**](https://lua-api.factorio.com/latest/events.html#on_gui_click) event
  + **``on_checked``** – ***function*** handler for  [**``on_gui_checked_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_checked_state_changed) event
  + **``on_selected``** – ***function*** handler for [**``on_gui_selection_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_selection_state_changed) event
  + **``on_value``** – ***function*** handler for [**``on_gui_value_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_value_changed) event
* **``admin``** – ***string*** the name of the super-admin that the additional module should be registered to. If the name provided does not belong to any of the super-admins then the registration **does not take place**. If ``nil`` then the functionality gets registered for every super-admin who currently is promoted to the status (*i.e. does not affect future super-admins*).

### Example of adding functionality during the runtime

This example depitcs process of registering of a simple additional module that has a button that prints ``Hello World!`` when pressed.

```lua
local draw_func = function(frame, superadmin)
  frame.add{
    type = "flow",
    name = "example_flow",
    direction = "horizontal"
  }

  KMinimalistStyling.apply_style(
    frame.flow,
    "fsac_extra_flow",
    { top_margin = 10, bottom_margin = 10 }
  )

  frame.example_flow.add{
    type = "button",
    name = "example_btn",
    caption = "Click me",
    mouse_button_filter = {"left"}
  }

  KMinimalistStyling.apply_style(
    frame.example_flow.example_btn,
    "fsac_extra_btn",
    { margin = 10 }
  )
end

local on_click_handler = function(event, superadmin)
  if event.element.name == "example_btn" then
    game.print("Hello World!")
  end
end

FSACExtra.register_functionality(
  "extra_example",
  "Example module",
  draw_func,
  {
    on_click = on_click_handler,
  },
  "YOUR_NAME_HERE"
)
```

## Managing super-admins

The script allows for: promoting, and demoting of super-admins as well as validating player's super-admin status.

### Function ``FSACSuperAdminManager.demote(name)``

Demotes a player from the super-admin status.

**Return value:** a ***boolean*** value that is ``true`` in case of a successful demotion.

* **``name``** – ***string*** the username of the player

### Function ``FSACSuperAdminManager.promote(name)``

Promotes a player to the super-admin status.

**Return value:** a ***boolean*** value that is ``true`` in case of a successful promotion.

* **``name``** – ***string*** the username of the player

### Function ``FSACSuperAdminManager.print(message, identifier)``

Prints a message to a super-admin.

* **``message``** – ***string*** the message to be printed
* **``identifier``** – ***string*** the player username of the super-admin that should see the message. If ``nil`` then all super-admins see the message

### Function ``FSACSuperAdminManager.is_superadmin(identifier)``

Checks if a player has the super-admin status.

**Return value:** returns values: ***boolean, number***. The first value is ``true`` when the player has the super-admin status. The second value is the unique index of the super-admin.

* **``identifier``** – ***string*** the username of the player

### Function ``FSACSuperAdminManager.get(index)``

This function gets the [super-admin table](#super-admin-table) for further manipulation.

**Return value:** a ***table*** that represents the super admin.

* **``index``** – ***number*** the unique index of the super-admin

### Function ``FSACSuperAdminManager.get_all()``

This function gets a list of all [super-admin tables](#super-admin-table) for further manipulation.

**Return value:** a ***table*** that represents the list of all super admins.

## Possible operations on super-admins

Each super-admin is represented in a table. The table has several functions that can be used to access super-admin's player information. Each table contains the data relevant to a certain super-admin.

### Super admin table

A **Lua** table that contains super-admin data. This table always contains the following elements:

* **``name``** – ***string*** the username of the corresponding player
* **``menu_enabled``** – a ***boolean***  value that is set to ``true`` when the FSAC menu is being displayed to this super-admin
* **``extras``** – a ***table*** that contains the data of the extra functionality registered to this super-admin. **It is recommended** to store the data of additional modules in this table. The element ``functionality`` of this table **MUST NOT** be overwritten.

### Function ``:get_index()``

Gets the index of the player in the ``game.players`` table.

**Return value:** ***number*** the index of the player in the ``game.players`` table. If the table contains no such player returns ``nil``.

### Function ``:get_gui()``

Gets GUI container table of the corresponding player.

**Return value:** ***table*** safe API object ([kminimalist safe API object](https://github.com/k-Knight/kminimalist#safe-api-object-functionality)) of the [LuaGui](https://lua-api.factorio.com/latest/LuaGui.html).

### Function ``:get_player()``

Gets the player object table of the corresponding player.

**Return value:** ***table*** safe API object ([kminimalist safe API object](https://github.com/k-Knight/kminimalist#safe-api-object-functionality)) of the [LuaPlayer](https://lua-api.factorio.com/latest/LuaPlayer.htmll).

### Example of work with super-admin table

```lua
-- promoting a player to super-admin status
FSACSuperAdminManager.promote("YOUR_NAME_HERE")
-- checking if a player has the super-admin status
local is_admin, index = FSACSuperAdminManager.is_superadmin("YOUR_NAME_HERE")

if is_admin == true then
  -- getting super-admin table
  local super_admin = FSACSuperAdminManager.get(index)
  -- saving my_variable (persists through save/load cycle)
  super_admin.extras.my_variable = "my_value"
  -- printing the username of the player
  game.print( super_admin:get_player().name )
  -- getting GUI container of the player
  local player_gui = super_admin:get_gui()
  -- creating frame in player GUI
  player_gui.top.add{
    type = "frame",
    name = "example_frame",
    caption = "example frame"
  }
end
```