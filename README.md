# FactorioSneakyControl
A script for the game Factorio that provides administrative and other functionality through GUI.

## What this script features

1. Select players that will shimmer with rainbow colors.
2. Execute **lua** scripts.
3. Manipulate game speed.
4. Promote and demote players to admin status.
5. Suppress console and chat for everyone, except for you.
6. Kill (including forever) or resurrect players.
7. Manipulate different characteristics of players.
7. Manipulate equipment of players.

## Configuring the script

To configure a script you just have to open **sneaky_main.lua** file and change the following line (*you have to enter your name for script to recognize you as game's master*):
```lua
  global.player_name = "YOUR_NAME_HERE"       --<<--<<--<<--<<  !!!!  CHANGE THIS  !!!!
 ```

## How to install a script

The script files include a default **control.lua** file if you want to inject a script into your **existing save** or you want to **play with achievements enabled**. Just copy all the script files into the save archive.

Otherwise, if you want to attach this script your custom **control.lua** script, just be make sure to require **sneaky_main.lua** at the end of your script.

## Adding extra modules

If you want to add extra modules to the script you can explore file **sneaky_main.lua** to see the interface description how to register additional functionality to the script.
