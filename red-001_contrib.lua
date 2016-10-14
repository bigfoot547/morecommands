-- Thank you red-001 for contributing to the morecommands mod!
-- It is greatly appreciated!

-- Setyaw by red-001
minetest.register_chatcommand("yaw", {
   params = "<yaw>",
   description = "Set player yaw",
   func = function(name, param)
	if (param ~= '') and tonumber(param) then
		local player = minetest.get_player_by_name(name)
        player:set_look_yaw(math.rad(param))
		return true, "Yaw set to "..param
	else
		minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
	end
	end,
})

-- Setpitch by red-001
minetest.register_chatcommand("setpitch", {
   params = "<pitch>",
   description = "Set player pitch",
   func = function(name, param)
      if (param ~= '') and tonumber(param) then
         local player = minetest.get_player_by_name(name)
         player:set_look_pitch(math.rad(param))
         return true, "Pitch set to "..param
      else
		 minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
      end
   end,
})
