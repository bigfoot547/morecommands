vanished_players = {}

-- Kill
-- Spawpoint
-- Clear
-- Getpos
-- Spawn
-- Hp
-- Heal
-- Breath
-- Vanish
-- Nick
-- Speed
-- Jump
-- Gravity
-- Tellraw
-- Sayraw
-- Sudo
-- Whitelist
-- List
-- Drop
-- Fnode
-- Butcher
-- Up
-- Down

-- TODO: Add print statements.

dofile(minetest.get_modpath("morecommands").."/orwell_contrib.lua")
dofile(minetest.get_modpath("morecommands").."/red-001_contrib.lua")

local start = os.clock()
local whitelist = {minetest.setting_get("name")}

minetest.register_privilege("vanish", {description = "Can vanish yourself", give_to_singleplayer = false})
minetest.register_privilege("vanishothers", {description = "Can vanish others", give_to_singleplayer = false})

minetest.register_chatcommand("vanish", {
	description = "Vanish <player>",
	params = "[player]",
	privs = {vanish = true},
	func = function(name, param)
		local targetname = (param:split(' ')[1] or name)
		local allowed = false
		local action
		if vanished_players[name] then
			action = "unvanish"
		else
			action = "vanish"
		end
		if minetest.check_player_privs(name, {vanishothers = true}) and (name ~= targetname) then
			allowed = true
		elseif minetest.check_player_privs(name, {vanishothers = false}) and name == targetname then
			allowed = true
		else
			allowed = false
		end
		if action and targetname then
			local target = minetest.get_player_by_name(targetname)
			if target and allowed then
				action = action:lower()
				if action == "vanish" then
					vanished_players[name] = true
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Vanished "..targetname.."]"))
					end
					print("[morecommands] "..name..": vanished "..targetname..".")
					if math.random(1, 5) == 1 then
						easter_egg(targetname)
					end
					target:set_properties({
						textures = {"hidden.png"},
						collisionbox = {0, 0, 0, 0, 0, 0}
					})
					target:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
				elseif action == "unvanish" then
					vanished_players[name] = false
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Unvanished "..targetname.."]"))
					end
					print("[morecommands] "..name..": unvanished "..targetname..".")
					if math.random(1, 5) == 1 then
						easter_egg(targetname)
					end
					target:set_properties({
						textures = {"character.png"},
						collisionbox = {-0.3333333, -1, -0.3333333, 0.3333333, 1, 0.3333333}
					})
					target:set_nametag_attributes({color = {a = 255, r = 255, g = 255, b = 255}})
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid first argument. Taking no action."))
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found or insufficiant privs."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})

minetest.register_privilege("nick", {description = "Can nickname"})

minetest.register_chatcommand("nick", {
	description = "Nickname yourself",
	params = "<nickname>",
	privs = {nick = true},
	func = function(name, param)
		local target = minetest.get_player_by_name(name)
		if minetest.get_modpath("rank") then
			target:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..param})
			if param == "" then
				target:set_nametag_attributes({text = "                                          ["..color(rank_colors[ranks[name]])..ranks[name]..color("#ffffff").."]: "..name})
			end
		else
			target:set_nametag_attributes({text = param})
			if param == "" then
				target:set_nametag_attributes({text = name})
			end
		end
		if math.random(1, 5) == 1 then
			easter_egg(name)
		end
		if minetest.setting_getbool("enable_command_feedback") then
			if param == "" then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Reset "..name.."'s nickname.]"))
			else
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Nicknamed "..name.." to \""..param.."\".]"))
			end
		end
		print("[morecommands] "..name..": nicknamed self \""..param.."\".")
	end
})

minetest.register_privilege("speed", {description = "Can set your speed", give_to_singleplayer = false})

minetest.register_chatcommand("speed", {
	description = "Set your speed",
	params = "set|reset <speed>",
	privs = {speed = true},
	func = function(name, param)
		local target = minetest.get_player_by_name(name)
		local action = param:split(' ')[1]
		local speed = tonumber(param:split(' ')[2])
		
		if action then
			action = action:lower()
			if action == "set" then
				if speed then
					target:set_physics_override({speed = speed})
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..name.."'s speed to "..tostring(speed)..".]"))
					end
					if math.random(1, 5) == 1 then
						easter_egg(target:get_player_name())
					end
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Speed."))
				end
			elseif action == "reset" then
				target:set_physics_override({speed = 1})
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Reset "..name.."'s speed.]"))
				end
				if math.random(1, 5) == 1 then
					easter_egg(target:get_player_name())
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid first argument. Taking no action."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})

minetest.register_privilege("jump", {description = "Can set jump height"})

minetest.register_chatcommand("jump", {
	description = "Set jump height",
	params = "set|reset <speed>",
	privs = {jump = true},
	func = function(name, param)
		local target = minetest.get_player_by_name(name)
		local action = param:split(' ')[1]
		local jump = tonumber(param:split(' ')[2])
		
		if action then
			action = action:lower()
			if action == "set" then
				if jump then
					target:set_physics_override({jump = jump})
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..name.."'s jump height to "..tostring(jump)..".]"))
					end
					if math.random(1, 5) == 1 then
						easter_egg(name)
					end
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Speed."))
				end
			elseif action == "reset" then
				target:set_physics_override({jump = 1})
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Reset "..name.."'s jump height.]"))
				end
				if math.random(1, 5) == 1 then
					easter_egg(name)
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid first argument. Taking no action."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})

minetest.register_privilege("gravity", {description = "Can set gravity"})

minetest.register_chatcommand("gravity", {
	description = "Set gravity",
	params = "set|reset <speed>",
	privs = {jump = true},
	func = function(name, param)
		local target = minetest.get_player_by_name(name)
		local action = param:split(' ')[1]
		local gravity = tonumber(param:split(' ')[2])
		
		if action then
			action = action:lower()
			if action == "set" then
				if gravity then
					target:set_physics_override({gravity = gravity})
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..name.."'s gravity to "..tostring(gravity)..".]"))
					end
					if math.random(1, 5) == 1 then
						easter_egg(name)
					end
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Gravity."))
				end
			elseif action == "reset" then
				target:set_physics_override({gravity = 1})
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Reset "..name.."'s gravity.]"))
				end
				if math.random(1, 5) == 1 then
					easter_egg(name)
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid first argument. Taking no action."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})

minetest.register_privilege("hp", {description = "Can change the hp of a player", give_to_singleplayer = false})

minetest.register_chatcommand("kill", {
	description = "Kill [player] or you",
	param = "[player]",
	privs = {hp = true},
	func = function(name, param)
		local target
		local targetname
		if param == "" then
			target = minetest.get_player_by_name(name)
		else
			target = minetest.get_player_by_name(param)
		end
		
		if target then
			targetname = target:get_player_name()
			target:set_hp(0)
			minetest.chat_send_player(name, "Killed " .. targetname .. ".")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "[".. name ..": Killed ".. targetname ..".]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(targetname)
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found: " .. param))		
		end
	end
})

minetest.register_privilege("spawnpoint", {description = "Can spawnpoint"})

minetest.register_chatcommand("spawnpoint", {
	description = "Set your spawnpoint",
	params = "",
	privs = {spawnpoint = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		beds.spawn[name] = vector.round(player:getpos())
		beds.save_spawns()
		minetest.chat_send_player(name, "Spawnpoint set.")
		if math.random(1, 5) == 1 then
			easter_egg(player:get_player_name())
		end
		if minetest.setting_getbool("enable_command_feedback") then
			minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..name.."'s spawnpoint to "..minetest.pos_to_string(vector.round(player:getpos())).."]"))
		end
	end
})

minetest.register_privilege("clear", {description = "Can clear player's inventory", give_to_singleplayer = false})

local function clear(pname, listname, itemname)
	local inv = minetest.get_inventory({type = "player", name = pname})
	local player = minetest.get_player_by_name(pname)
	if not player then return nil end
	if not inv then return nil end
	local list = inv:get_list(listname)
	if not list then return nil end
	local index, stack
	local count = 0
	local ss
	
	for index, stack in pairs(list) do
		if itemname == "*" then ss = stack:get_name() else ss = itemname end
		if (not inv:get_stack(listname, index):is_empty()) and stack:get_name() == ss then
			inv:set_stack(listname, index, ItemStack(""))
			count = count + 1
		end
	end
	return count
end

minetest.register_chatcommand("clear", {
	description = "Clear [player]'s inventory",
	params = "[player] [stackstring]",
	privs = {clear = true},
	func = function(name, param)
		local user = minetest.get_player_by_name(name)
		local target = minetest.get_player_by_name(param:split(' ')[1] or "")
		local itemstring = param:split(' ')[2] or "*"
		local cleareditems
		if param == "" then
			target = user
		end
		if target then
			local count = 0
			count = count + (clear(name, "main", itemstring) or 0)
			count = count + (clear(name, "craft", itemstring) or 0)
			count = count + (clear(name, "craftpreview", itemstring) or 0)
			count = count + (clear(name, "craftresult", itemstring) or 0)
			if minetest.get_modpath("unified_inventory") then
				count = count + (clear(name, "bag1", itemstring))
				count = count + (clear(name, "bag2", itemstring))
				count = count + (clear(name, "bag3", itemstring))
				count = count + (clear(name, "bag4", itemstring))
			end
			if minetest.get_modpath("3d_armor") then
				count = count + (clear(name, "armor",  itemstring))
			end
			minetest.chat_send_player(name, "Cleared inventory of "..target:get_player_name()..", emptied "..tostring(count).." stack(s).")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Cleared inventory of "..target:get_player_name()..", emptied "..tostring(count).." stack(s).]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(target:get_player_name())
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found: "..param))
		end
	end
})

minetest.register_privilege("getpos", {description = "Can use the getpos command"})

minetest.register_chatcommand("getpos", {
	description = "See <player>'s position",
	params = "<player>",
	privs = {getpos = true},
	func = function(name, param)
		target = minetest.get_player_by_name(param)
		if target then
			minetest.chat_send_player(name, param.."'s position is "..minetest.pos_to_string(target:getpos())..".")
			minetest.chat_send_player(param, minetest.colorize("#FFFF00", name.." is tracking you!"))
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Saw "..param.."'s position.]"))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found: "..param.."."))
		end
	end
})

minetest.register_privilege("spawn", {description = "Can use the spawn command"})

minetest.register_chatcommand("spawn", {
	description = "Teleport to spawnpoint",
	params = "",
	privs = {spawn = true},
	func = function(name, param)
		if beds.spawn[name] then
			minetest.get_player_by_name(name):setpos(beds.spawn[name])
			minetest.chat_send_player(name, "Teleported to spawn.")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Teleported to spawnpoint.]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(name)
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "You need to spawnpoint first"))
		end
	end
})

minetest.register_chatcommand("hp", {
	description = "Set <player>'s hp",
	params = "<player> [hp]",
	privs = {hp = true},
	func = function(name, param)
		local params = param:split(' ')
		if not params[1] then params[1] = "" end
		local target = minetest.get_player_by_name(params[1])
		local hp = tonumber(params[2])
		
		if target and hp then
			target:set_hp(hp)
			minetest.chat_send_player(name, "Set "..target:get_player_name().."'s hp to "..hp..".")
			minetest.chat_send_player(target:get_player_name(), minetest.colorize("#FFFF00", name.." changed your hp to "..hp.."!"))
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..target:get_player_name().."'s hp.]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(target:get_player_name())
			end
		elseif target and not hp then
			minetest.chat_send_player(name, params[1].."'s hp is "..tostring(target:get_hp())..".")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Queried "..target:get_player_name().."'s hp.]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(target:get_player_name())
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid usage."))
		end
	end
})

minetest.register_privilege("breath", {description = "Can change a player's breath", give_to_singleplayer = false})

minetest.register_chatcommand("heal", {
	description = "Heal [player].",
	params = "[player]",
	privs = {hp = true, breath = true},
	func = function(name, param)
		if param == "" then param = name end
		local target = minetest.get_player_by_name(param)
		if target then
			target:set_hp(20)
			target:set_breath(11)
			minetest.chat_send_player(name, param.." healed.")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Healed "..param..".]"))
				if param ~= name then minetest.chat_send_player(param, minetest.colorize("#FFFF00", name.." healed you!")) end
			end
			if math.random(1, 5) == 1 then
				easter_egg(param)
			end
		else
			minetest.chat_send_player(name, "Player not found: "..param..".")
		end
	end
})

minetest.register_chatcommand("breath", {
	description = "Set <player>'s breath",
	params = "<player> <breath>",
	privs = {breath = true},
	func = function(name, param)
		local params = param:split(' ')
		if not params[1] then params[1] = "" end
		local target = minetest.get_player_by_name(params[1])
		local hp = tonumber(params[2])
		
		if target and hp then
			target:set_breath(hp)
			minetest.chat_send_player(name, "Set "..target:get_player_name().."'s breath to "..hp..".")
			minetest.chat_send_player(target:get_player_name(), minetest.colorize("#FFFF00", name.." changed your breath to "..hp.."!"))
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..target:get_player_name().."'s breath.]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(target:get_player_name())
			end
		elseif target and not hp then
			minetest.chat_send_player(name, params[1].."'s breath is "..tostring(target:get_breath())..".")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Queried "..target:get_player_name().."'s breath.]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(target:get_player_name())
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid usage."))
		end
	end
})

minetest.register_privilege("sayraw", {description = "Can use the /sayraw command"})
minetest.register_privilege("tellraw", {description = "Can use the /tellraw command"})

minetest.register_chatcommand("sayraw", {
	description = "Say <message> without a header",
	params = "[message]",
	privs = {sayraw = true},
	func = function(name, param)
		minetest.chat_send_all(param)
		if math.random(1, 5) == 1 then
			easter_egg(name)
		end
	end
})

minetest.register_chatcommand("tellraw", {
	description = "Tell <player> [message]",
	params = "<player> [message]",
	privs = {tellraw = true},
	func = function(name, param)
		local target = minetest.get_player_by_name(param:sub(1, param:find(' ') - 1))
		local message = param:sub(param:find(' ') + 1, nil)
		if target then
			minetest.chat_send_player(target:get_player_name(), message)
			if math.random(1, 5) == 1 then
				easter_egg(target:get_player_name())
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Player not found: "..(param:sub(1, param:find(' ') - 1)..".")))
		end
	end
})

minetest.register_privilege("sudo", {description = "Can use the /sudo command"})

minetest.register_chatcommand("sudo", {
	description = "Force other players to run commands",
	params = "<player> <command> <arguments...>",
	privs = {server = true, sudo = true},
	func = function(name, param)
		local target = param:split(' ')[1]
		local command = param:split(' ')[2]
		local arguments
		local argumentsdisp
		local cmddef = minetest.chatcommands
		_, _, arguments = string.match(param, "([^ ]+) ([^ ]+) (.+)")
		if not arguments then arguments = "" end
		if target and command then
			if cmddef[command] then
				if minetest.get_player_by_name(target) then
					if arguments == "" then argumentsdisp = arguments else argumentsdisp = " "..arguments end
					if minetest.setting_getbool("enable_forced_command_feedback") and minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Forced "..target.." to run command \"/"..command..argumentsdisp.."\".]"))
					end
					cmddef[command].func(target, arguments)
					if math.random(1, 5) == 1 then
						easter_egg(target)
					end
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Player."))
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Nonexistant Command."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})

do
	whitelist = {minetest.setting_get("name"), "singleplayer"}
	local filepath = minetest.get_worldpath().."/whitelist.mt"
	local file = io.open(filepath, "r")
	if file then
		minetest.log("action", "[morecommands] whitelist.mt opened.")
		local string = file:read()
		io.close(file)
		if(string ~= nil) then
			local savetable = minetest.deserialize(string)
			whitelist = savetable
			minetest.debug("[morecommands] whitelist.mt successfully read.")
		end
	end
end

local function save()
	local savetable = {}
	savetable = whitelist

	local savestring = minetest.serialize(savetable)

	local filepath = minetest.get_worldpath().."/whitelist.mt"
	local file = io.open(filepath, "w")
	if file then
		file:write(savestring)
		io.close(file)
		minetest.log("action", "[morecommands] Wrote whitelist data into "..filepath..".")
	else
		minetest.log("error", "[morecommands] Failed to write whitelist data into "..filepath..".")
	end
end

minetest.register_privilege("whitelist", {description = "Modify the server's whitelist", give_to_singleplayer = false})

minetest.register_chatcommand("whitelist", {
	description = "Modify server whitelist. Refer to \"/whitelist help\" for help.",
	params = "get|on|off|help|add|remove|check <subcommand arguments...>",
	privs = {whitelist = true, ban = true, kick = true},
	func = function(name, param)
		local subcommand
		local subparams
		subcommand, subparams = string.match(param, "([^ ]+) *(.*)")
		if subcommand then
			subcommand = subcommand:lower()
			if subcommand == "help" then
				minetest.chat_send_player(name, minetest.colorize("#00FFFF", "Help")..": Display this help message.\n"..
				minetest.colorize("#00FFFF", "Get")..": Display a list of the people on the whitelist.\n"..
				minetest.colorize("#00FFFF", "On")..": Turn whitelist on.\n"..
				minetest.colorize("#00FFFF", "Off")..": Turn whitelist off.\n"..
				minetest.colorize("#00FFFF", "Add")..": Add a specified player to the whitelist.\n"..
				minetest.colorize("#00FFFF", "Remove")..": Remove a specified player from the whitelist."
				)
			elseif subcommand == "add" then
				_, subparams = string.match(param, "([^ ]+) ([^ ]+)")
				if subparams then
					table.insert(whitelist, #whitelist + 1, subparams)
					save()
					minetest.chat_send_player(name, "\""..subparams.."\" added to whitelist.")
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Added "..subparams.." to the whitelist.]"))
					end
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Argument."))
				end
			elseif subcommand == "on" then
				minetest.setting_setbool("whitelist", true)
				minetest.chat_send_player(name, "Whitelist enabled.")
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Enabled whitelist on the server.]"))
				end
			elseif subcommand == "off" then
				minetest.setting_setbool("whitelist", false)
				minetest.chat_send_player(name, "Whitelist disabled.")
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Disabled whitelist on the server.]"))
				end
			elseif subcommand == "get" then
				minetest.chat_send_player(name, "List of people on whitelist:\n"..dump(whitelist))
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Saw the whitelist.]"))
				end
			elseif subcommand == "remove" then
				_, subparams = string.match(param, "([^ ]+) ([^ ]+)")
				local index = nil
				if subparams then
					for i = 1, #whitelist do
						if whitelist[i] == subparams then
							index = i
						end
					end
					if index then
						table.remove(whitelist, index)
						minetest.chat_send_player(name, subparams.." removed from the whitelist.")
						if minetest.setting_getbool("enable_command_feedback") then
							minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Removed "..subparams.." from whitelist.]"))
						end
					else
						minetest.chat_send_player(name, minetest.colorize("#FF0000", subparams.." was not on the whitelist."))
					end
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Argument."))
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Subcommand."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage. See /whitelist help for assistance."))
		end
	end
})

minetest.register_on_shutdown(function()
	save()
end)

--minetest.register_on_joinplayer(function(player)
	--local found = true
	--if minetest.setting_getbool("whitelist") and player:get_player_name() ~= "singleplayer" then
		--found = false
		--for i = 1, #whitelist do
			--if player:get_player_name() == whitelist[i] then
				--found = true 
				--break
			--end
		--end
	--end
	--if not found then
		--minetest.kick_player(player:get_player_name(), "Your name is not on the whitelist.\nThe server has been notified.")
		--minetest.chat_send_all(minetest.colorize("#FFBF00", "A player, "..player:get_player_name()..", has been kicked from the server because he is not on the whitelist."))
	--end
--end)

minetest.register_on_prejoinplayer(function(name, ip)
	local found = true
	if minetest.setting_getbool("whitelist") and name ~= "singleplayer" then
		found = false
		for i = 1, #whitelist do
			if name == whitelist[i] then
				found = true 
				break
			end
		end
	end
	if not found then
		if minetest.get_modpath("rank") then
			local key, value
			for key, value in pairs(ranks) do
				if value == "moderator" or value == "admin" and minetest.get_player_by_name(key) then
					minetest.chat_send_player(key, minetest.colorize("#FFBF00", "[")..minetest.colorize("#FF0000", "Admin/Moderator Only")..minetest.colorize("#FFBF00", "] A player, "..name.." ("..ip.."), has been been disallowed to join the server because "..name.." is not on the whitelist."))
				end
			end
		else
			if minetest.setting_get("name") then
				minetest.chat_send_all(minetest.colorize("#FFBF00", "[")..minetest.colorize("#FF0000", "Owner Only")..minetest.colorize("#FFBF00", "] A player, "..name.." ("..ip.."), has been been disallowed to join the server because "..name.." is not on the whitelist."))
			end
		end
		return "Your name is not on the whitelist.\nThe server has been notified and saw your ip: "..ip.."."
	end
end)

minetest.register_chatcommand("list", {
	description = "List players on the server",
	params = "",
	privs = {},
	func = function(name, param)
		local playerstring = ""
		for i, player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if i < #minetest.get_connected_players() then
				playerstring = playerstring..name..", "
			else
				playerstring = playerstring..name
			end
		end
		if math.random(1, 5) == 1 then
			easter_egg(name)
		end
		minetest.chat_send_player(name, playerstring)
	end
})

minetest.register_privilege("fnode", {description = "San spawn falling nodes"})

minetest.register_chatcommand("fnode", {
	description = "Spawn a falling node at <x> <y> <z>",
	params = "<node> <x> <y> <z>",
	privs = {fnode = true},
	func = function(name, param)
		local x = param:split(' ')[2]
		local y = param:split(' ')[3]
		local z = param:split(' ')[4]
		local node = param:split(' ')[1]
		x = tonumber(x)
		y = tonumber(y)
		z = tonumber(z)
		if minetest.registered_nodes[node] then
			if node and x and y and z then
				local obj = minetest.add_entity({x=x, y=y, z=z}, "__builtin:falling_node")
				if obj then
					obj:get_luaentity():set_node({name = node})
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
			end
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Spawned the falling node "..node..".]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(name)
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Node."))
		end
	end
})

minetest.register_chatcommand("drop", {
	description = "Spawn a dropped item at <x> <y> <z>",
	params = "<item> <x> <y> <z>",
	privs = {fnode = true},
	func = function(name, param)
		local x = param:split(' ')[2]
		local y = param:split(' ')[3]
		local z = param:split(' ')[4]
		local node = param:split(' ')[1]
		x = tonumber(x)
		y = tonumber(y)
		z = tonumber(z)
		if minetest.registered_items[node] then
			if node and x and y and z then
				local obj = minetest.add_entity({x=x, y=y, z=z}, "__builtin:item")
				if obj then
					obj:get_luaentity():set_item({name = node})
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
			end
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Spawned the dropped item "..node..".]"))
			end
			if math.random(1, 5) == 1 then
				easter_egg(name)
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Itemname."))
		end
	end
})

minetest.register_chatcommand("up", {
	description = "Go up [levels] number of levels.",
	params = "[levels]",
	privs = {teleport = true},
	func = function(name, param)
		local levels = tonumber(param) or 1
		local pos = minetest.get_player_by_name(name):getpos()
		
		local i, j = 0, 1
		local node
		
		if not minetest.get_player_by_name(name) then
			print(name .. " is not a client.")
			return false
		end
		
		j = math.ceil(pos.y) + 1
		
		for i = 1, levels do
			while true do
				node = minetest.get_node({x = pos.x, y = j, z = pos.z})
				if node.name == "ignore" then
					minetest.chat_send_player(name, minetest.colorize("#FFFF00", "No nodes found untill unloaded chunks."))
					return false
				elseif node and minetest.registered_nodes[node.name].walkable and not minetest.registered_nodes[minetest.get_node({x = pos.x, y = j + 1, z = pos.z}).name].walkable and not minetest.registered_nodes[minetest.get_node({x = pos.x, y = j + 2, z = pos.z}).name].walkable then
					minetest.chat_send_player(name, "Found a node at y = "..math.ceil(tostring(j + 1))..".")
					minetest.get_player_by_name(name):setpos({x = pos.x, y = math.ceil(j + 1), z = pos.z})
					j = j + 1
					break
				end
				j = j + 1
			end
		end
	end
})

minetest.register_chatcommand("down", {
	description = "Go down [levels] number of levels.",
	params = "[levels]",
	privs = {teleport = true},
	func = function(name, param)
		local levels = tonumber(param) or 1
		local pos = minetest.get_player_by_name(name):getpos()
		
		local i, j
		local node
		
		if not minetest.get_player_by_name(name) then
			print(name .. " is not a client.")
			return false
		end
		
		j = math.ceil(pos.y) - 2
		
		for i = 1, levels do
			while true do
				node = minetest.get_node({x = pos.x, y = j, z = pos.z})
				if node.name == "ignore" then
					minetest.chat_send_player(name, minetest.colorize("#FFFF00", "No nodes found untill unloaded chunks."))
					return false
				elseif node and minetest.registered_nodes[node.name].walkable and not minetest.registered_nodes[minetest.get_node({x = pos.x, y = j + 1, z = pos.z}).name].walkable and not minetest.registered_nodes[minetest.get_node({x = pos.x, y = j + 2, z = pos.z}).name].walkable then
					minetest.chat_send_player(name, "Found a node at y = "..math.ceil(tostring(j + 1))..".")
					minetest.get_player_by_name(name):setpos({x = pos.x, y = math.ceil(j + 1), z = pos.z})
					j = j - 1
					break
				end
				j = j - 1
			end
		end
	end
})

function G(text)
	return minetest.colorize("#00FB00", text)
end
function R(text)
	return minetest.colorize("#FF0000", text)
end

minetest.register_privilege("butcher", {description = "Can use the /butcher command."})

minetest.register_chatcommand("butcher", {
	description = "Remove entities of a specific type. Type "..minetest.colorize("#ffff00", "/butcher -h").." for more information.",
	params = "[-afhimM]",
	privs = {butcher = true},
	func = function(name, param)
		if param:sub(2, 2) == 'h' then
			minetest.chat_send_player(name, "-a: Remove all entities")
			minetest.chat_send_player(name, "-f: Remove all farm animals")
			minetest.chat_send_player(name, "-h: Show this help message")
			minetest.chat_send_player(name, "-i: Remove all dropped items")
			minetest.chat_send_player(name, "-m: Remove all mobs")
			minetest.chat_send_player(name, "-M "..minetest.colorize("#00FFFF", "[Default]")..": Remove all monsters")
			minetest.chat_send_player(name, "If multiple options specified, only the first one will be executed")
			return
		end
		local option = param:sub(2, 2)
		if option == "" and param == "" then option = "M" end
		local test
		local count, tot = 0, 0
		local key, val
		local start, ennd, mid
		start = os.clock()
		for key, val in pairs(minetest.luaentities) do
			tot = tot + 1
		end
		for key, val in pairs(minetest.luaentities) do
			local def = minetest.registered_entities[minetest.luaentities[key].name]
			if option == "M" then
				test = (def.type =="monster")
			elseif option == "a" then
				test = true
			elseif option == "f" then
				test = (def.type == "animal")
			elseif option == "i" then
				test = (val.name == "__builtin:item")
			elseif option == "m" then
				test = (def.type == "monster" or def.type == "animal")
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid option."))
				return
			end
			if test then
				minetest.luaentities[key].object:remove()
				count = count + 1
			end
		end
		ennd = os.clock()
		mid = ennd - start
		minetest.chat_send_player(name, G("Removed ")..R(tostring(count))..G(" / ")..R(tostring(tot))..G(" luaentities in ")..R(tostring(math.floor(mid * 1000000)))..G(" µs."))
		if minetest.setting_getbool("enable_command_feedback") then
			minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Removed "..tostring(count).." / "..tostring(tot).." luaentities with the argument: "..option..".]"))
		end
	end
})

--minetest.register_chatcommand("easter", {
--	func = function(name, param)
--		easter_egg(name)
--	end
--})


function rand_color()
	local hex = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
	return hex[math.random(1, 16)]..hex[math.random(1, 16)]..hex[math.random(1, 16)]..hex[math.random(1, 16)]..hex[math.random(1, 16)]..hex[math.random(1, 16)]
end

function easter_egg(name)
	local pos = minetest.get_player_by_name(name):getpos()
	minetest.add_particlespawner({
		amount = 20,
		time = 0.1,
		minpos = pos,
		maxpos = {x = pos.x, y = pos.y + 2, z = pos.z},
		minvel = {x = -1, y = -1, z = -1},
		maxvel = {x = 1, y = -0, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minsize = 1,
		maxsize = 1,
		minexptime = 0.5,
		maxexptime = 0.75,
		collisiondetection = true,
		vertical = false,
		texture = "particle_0.png^[colorize:#"..rand_color()
	})
	minetest.add_particlespawner({
		amount = 20,
		time = 0.1,
		minpos = pos,
		maxpos = {x = pos.x, y = pos.y + 2, z = pos.z},
		minvel = {x = -1, y = -1, z = -1},
		maxvel = {x = 1, y = -0, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minexptime = 0.5,
		maxexptime = 0.75,
		minsize = 1,
		maxsize = 1,
		collisiondetection = true,
		vertical = false,
		texture = "particle_1.png^[colorize:#"..rand_color()
	})
	minetest.add_particlespawner({
		amount = 20,
		time = 0.1,
		minpos = pos,
		maxpos = {x = pos.x, y = pos.y + 2, z = pos.z},
		minvel = {x = -1, y = -1, z = -1},
		maxvel = {x = 1, y = -0, z = 1},
		minacc = {x = -1, y = 1, z = -1},
		maxacc = {x = 1, y = -1, z = 1},
		minexptime = 0.5,
		maxexptime = 0.75,
		minsize = 1,
		maxsize = 1,
		collisiondetection = true,
		vertical = false,
		texture = "particle_2.png^[colorize:#"..rand_color()
	})
end

print("[morecommands] Mod loaded in "..tostring(math.floor((os.clock() - start)*1000000)).."µs.")
