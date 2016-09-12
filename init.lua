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

local whitelist = {minetest.setting_get("name")}

minetest.register_privilege("vanish", {description = "Can vanish yourself", give_to_singleplayer = false})
minetest.register_privilege("vanishothers", {description = "Can vanish others", give_to_singleplayer = false})

minetest.register_chatcommand("vanish", {
	description = "Vanish <player>",
	params = "vanish|unvanish <player>",
	privs = {vanish = true},
	func = function(name, param)
		local action = param:split(' ')[1]
		local targetname = param:split(' ')[2]
		local allowed = false
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
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Vanished "..targetname.."]"))
					end
					if math.random(1, 5) == 1 then
						easter_egg(targetname)
					end
					target:set_properties({
						textures = {"hidden.png"},
						collisionbox = {0, 0, 0, 0, 0, 0}
					})
					target:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
				elseif action == "unvanish" then
					if minetest.setting_getbool("enable_command_feedback") then
						minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Unvanished "..targetname.."]"))
					end
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
		target:set_nametag_attributes({text = param})
		if param == "" then
			target:set_nametag_attributes({text = name})
		end
		if math.random(1, 5) == 1 then
			easter_egg(name)
		end
		if minetest.setting_getbool("enable_command_feedback") then
			minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Nicknamed himself to \""..param.."\".]"))
		end
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
				target:set_physics_override({jump = jump})
				if minetest.setting_getbool("enable_command_feedback") then
					minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..name.."'s jump height to "..tostring(jump)..".]"))
				end
				if math.random(1, 5) == 1 then
					easter_egg(name)
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
		
		targetname = target:get_player_name()
		
		if target then
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
		beds.spawn[name] = player:getpos()
		beds.save_spawns()
		minetest.chat_send_player(name, "Spawnpoint set.")
		if math.random(1, 5) == 1 then
			easter_egg(player:get_player_name())
		end
		if minetest.setting_getbool("enable_command_feedback") then
			minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Set "..name.."'s spawnpoint.]"))
		end
	end
})

minetest.register_privilege("clear", {description = "Can clear player's inventory", give_to_singleplayer = false})

minetest.register_chatcommand("clear", {
	description = "Clear [player]'s inventory",
	params = "[player]",
	privs = {clear = true},
	func = function(name, param)
		local user = minetest.get_player_by_name(name)
		local target = minetest.get_player_by_name(param)
		local cleareditems
		if param == "" then
			target = user
		end
		if target then
			target:get_inventory():set_list("main", {})
			target:get_inventory():set_list("craft", {})
			target:get_inventory():set_list("craftpreview", {})
			target:get_inventory():set_list("craftresult", {})
			minetest.chat_send_player(name, "Cleared "..target:get_player_name().."'s inventory.")
			if minetest.setting_getbool("enable_command_feedback") then
				minetest.chat_send_all(minetest.colorize("#7F7F7F", "["..name..": Cleared "..target:get_player_name().."'s inventory.]"))
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
			minetest.chat_send_player(name, "Telleported to spawn.")
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
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid usage: /hp "..param.."."))
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
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid usage: /breath "..param.."."))
		end
	end
})

minetest.register_privilege("sayraw", {description = "Can use the /sayraw command"})
minetest.register_privilege("tellraw", {description = "Can use the /tellraw command"})

minetest.register_chatcommand("sayraw", {
	description = "Say <message> without a header",
	params = "[message]",
	privs = {sayraw = true, say = true},
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
	privs = {tell = true},
	func = function(name, param)
		local target = minetest.get_player_by_name(param:sub(1, param:find(' ') - 1))
		local message = param:sub(param:find(' ') + 1, nil)
		minetest.chat_send_player(target:get_player_name(), message)
		if math.random(1, 5) == 1 then
			easter_egg(target:get_player_name())
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

minetest.register_on_joinplayer(function(player)
	local found = true
	if minetest.setting_getbool("whitelist") and player:get_player_name() ~= "singleplayer" then
		found = false
		for i = 1, #whitelist do
			if player:get_player_name() == whitelist[i] then
				found = true 
				break
			end
		end
	end
	if not found then
		minetest.kick_player(player:get_player_name(), "Your name is not on the whitelist.\nThe server has been notified.")
		minetest.chat_send_all(minetest.colorize("#FFBF00", "A player, "..player:get_player_name()..", has been kicked from the server because he is not on the whitelist."))
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

minetest.register_chatcommand("easter", {
	func = function(name, param)
		easter_egg(name)
	end
})


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
		texture = "particle.png^[colorize:#"..rand_color()
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
		texture = "particle.png^[colorize:#"..rand_color()
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
		texture = "particle.png^[colorize:#"..rand_color()
	})
end
