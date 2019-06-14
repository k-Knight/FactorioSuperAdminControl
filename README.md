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

## Adding extra modules during the cotrol stage

To register extra functionality during the control stage 3 following steps need to be done.

1. Create your script and place it in ``fsac/extra/`` folder.
2. At the end of your script file make a call to [``FSACExtra.static_register``](#function-fsacextrastatic_registername-button_caption-draw_function-handlers) function with the appropriate arguments.
3. As **Lua** language does not support including script files, it is necessary to add a ``require(path_to_your_file)`` statement in the ``fsac/fsac_main.lua`` file **AFTER** the ``require`` statement for ``fsac_extra.lua`` file.
   ```lua
   require("./fsac_extra.lua") -- extra menu functionality

   require("./extra/your_module_name.lua")
   ```

### Function ```FSACExtra.static_register(name, button_caption, draw_function, handlers)```

This function adds the registration of additional functionality to all super-admins. It should be noted that this function **MUST NOT** be called during the runtime of the game and only during the control stage because of possible desyncs.

* **``name``** – ***[string]*** the unique identifier of the additional module
* **``button_caption``** – ***[string]*** the caption of the button that will be displayed in extra functionality menu (*readable name of the additional module*)
* **``draw_function``** – ***[function]*** the draw function of additional module as an argument should take a frame [**``LuaGuiElement``**](https://lua-api.factorio.com/latest/LuaGuiElement.html)
* **``handlers``** – ***[table]*** with handlers for GUI events, has the following elements:
  + **``on_click``** – ***[function]*** handler, takes event arguments of [**``on_gui_click``**](https://lua-api.factorio.com/latest/events.html#on_gui_click) event
  + **``on_checked``** – ***[function]*** handler, takes event arguments of [**``on_gui_checked_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_checked_state_changed) event
  + **``on_selected``** – ***[function]*** handler, takes event arguments of [**``on_gui_selection_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_selection_state_changed) event
  + **``on_value``** – ***[function]*** handler, takes event arguments of [**``on_gui_value_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_value_changed) event


## Adding extra modules during runtime

The script supports also registration of additional functionality during runtime. The registration needs to be done by calling the ``FSACExtra.register_extra_functionality`` function with the appropriate arguments.

This can be viewed as a more personalized approach for registering functionality as the functionality can get added to the only super-admin provided in the ``admin`` argument of aforementioned function. It should be mentioned that any function of the additional module that is not provided in the function arguments **must be saved** to the ``global`` table of the game to persist through the save / load cycle.

### Function ```FSACExtra.register_extra_functionality(name, button_caption, draw_function, handlers, admin)```

As described above, this function registers additional module to a specific super-admin. This function **DOES NOT** work during the control stage of the game.

* **``name``** – ***[string]*** the unique identifier of the additional module
* **``button_caption``** – ***[string]*** the caption of the button that will be displayed in extra functionality menu (*readable name of the additional module*)
* **``draw_function``** – ***[function]*** the draw function of additional module as an argument should take a frame [**``LuaGuiElement``**](https://lua-api.factorio.com/latest/LuaGuiElement.html)
* **``handlers``** – ***[table]*** with handlers for GUI events, has the following elements:
  + **``on_click``** – ***[function]*** handler, takes event arguments of [**``on_gui_click``**](https://lua-api.factorio.com/latest/events.html#on_gui_click) event
  + **``on_checked``** – ***[function]*** handler, takes event arguments of [**``on_gui_checked_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_checked_state_changed) event
  + **``on_selected``** – ***[function]*** handler, takes event arguments of [**``on_gui_selection_state_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_selection_state_changed) event
  + **``on_value``** – ***[function]*** handler, takes event arguments of [**``on_gui_value_changed``**](https://lua-api.factorio.com/latest/events.html#on_gui_value_changed) event
* **``admin``** – ***[string]*** the name of the super-admin that the additional module should be registered to. If the name provided does not belong to any of the super-admins then the registration **does not take place**. If ``nil`` then the functionality gets registered for every super-admin who currently is promoted to the status (*i.e. does not affect future super-admins*).