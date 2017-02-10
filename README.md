# morecommands

## Description
This is a mod for minetest which adds a lot of different commands.
These commands are mostly admin commands, but some are not.

### This mod will allow you to:

  * Set the hp of players to 0 using the /kill command
  * Set your spawnpoint using the /spawnpoint command
  * Clear a player's inventory with the /clear command
  * Get the position of a player using the /getpos command
  * Teleport to the spawnpoint using the /spawn command
  * Set the hp of a player using the /hp command
  * Heal a player using the /heal command
  * Set the breath  (Air bubbles) of a player using the /breath command
  * Vanish or unvanish a player using the /vanish command
  * Nickname yourself using the /nick command
  * Set your walking speed with the /speed command
  * Set your jump height with the /jump command
  * Set your gravity using the /gravity command
  * Spawn a dropped item using the /drop command
  * Spawn a falling node with the /fnode command
  * Tell someone something without the header with the /tellraw command
  * Say something to the whole server without a header using the /sayraw command
  * Force a player to run a command using the /sudo command
  * Set a server whitelist using the /whitelist command
  * List the players on the server using the /list command
  * Go up a specified ammount of layers with the /up command
  * Go down a specified ammount of layers with the /down command
  * Remove all luaentities with the type monster with the /butcher command
  * Teleport thru walls with the /thru command
  * Return to a previous location after teleporting with the /back command

# A little more...
In order to make the /back command work with your mod, follow these steps:

 * Add `morecommands` to `depends.txt`
 * **Before** your mod teleports the player, set `back_pos[name]` to the player's *rounded* position, replacing `name` with the player's name.
 * You're done! You can now type /back after you get teleported.

## Licence
**Code: LGPL v2.1**

**Textures & Models: CC-BY 3.0 Unported**

## What else can this do?
  * This uses the "enable_command_feedback" setting to send a message to everyone when someone runs a command.
  * This also uses the "enable_forced_command_feedback" setting to tell the server when someone forces another
      player to run a command.
  * This mod adds many command aliases

# Orwell's Contributions

There have been some contributions made to this mod by: orwell on the forums.
Here is some ***long*** overdue documentation.

## Orwell's Contribution Documentation

### Commands added
 * Check if the server is responding with the /ping command.
 * Search registered tools, items, and nodes for a search term with the /ilist command.
 * Print the itemstring of the item in your hand with the /pwii command. (Works fine with unknown items.)
 * Print information on a player using the /pinfo command. (You need the server priv.)
 * Print the metadata of the node you are in with the /dumpmeta command.
 * Print a specefic key of the metadata of the block you are in with the /getmeta command. (So to find the owner of a door, stand in the doorway and type "/getmeta owner". If you have any trouble, PM me on the forums.)
 * Set a specific key of the metadata of the block you are in with the setmeta command. (So to make yourself the owner of a door, stand in the doorway and type "/setmeta owner *yourname*".)
 * Show a formspec to everyone with a big area to type in text with the /broadcast command.
 * Show a formspec to *someone* with a big area to type in text with the /showtext command.
 * Numerous command aliases.

#### Aliases added
 * /teleport = /tp
 * /giveme = /gm, /i
 * /shutdown = /sd, /stop
 * /ilist = /il
 * /list = /l
 * /kick = /ki
 * /ban = /b
 * /unban = /ub
 * /broadcast = /bc
 * /pulverize = /pv, /p
 * /grant = /gt
 * /revoke = /rv
 * /heal = /h
 * /kill = /k
 * /clearobjects = /co
 * /spawn = /s
 * /spawnpoint = /sp
 * /vanish = /v
 * /clear = /c
 * /up = /u
 * /down = /d

### Tools Added
 * The admintool destroys blocks and entities. Itemstring: "morecommands:admintool". (Need server priv.)
 * The infotool tells you the position and data (itemstring, facedir, light) of a node you punch. (Need server priv.) Itemstring: "morecommands:infotool"

# Up and Coming
I am wanting to add print statements to keep track of commands in the terminal.

# Credits
 * Mod created by: bigfoot547
 * With contributions made by: orwell and red-001
 * Contributions tweaked by: bigfoot547
 * With special thanks to Wuzzy for suggestions
