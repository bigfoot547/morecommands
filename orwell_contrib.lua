--		This part of the mod is contributed my orwell on the forums!
--		
--
--		Now for credits:
--		Mod by bigfoot547
--		With contributions made by orwell
--		And special thanks to Wuzzy for suggestions

--an easy way to try if and after what time the server is answering
core.register_chatcommand("ping", {
   params = "",
   description = "Ping",
   privs = {},
   func = function(name, param)
      return true, "Pong!"
   end,
})

core.register_chatcommand("ilist", {
   params = "[search term]",
   description = "Find item names or list all items",
   privs = {},
   func = function(name, param)
      --minetest.chat_send_player(name, "")
      local parami=""
      if param~=nil then
         parami=param
      end
      minetest.chat_send_player(name,"------------------------nodes")
      for n, i in pairs(core.registered_nodes) do
         if string.find(n, parami, 1, true) then
            minetest.chat_send_player(name, n)
         end
      end
      minetest.chat_send_player(name,"------------------------tools")
      for n, i in pairs(core.registered_tools) do
         if string.find(n, parami, 1, true) then
            minetest.chat_send_player(name, n)
         end
      end
      minetest.chat_send_player(name,"------------------------craftitems")
      for n, i in pairs(core.registered_craftitems) do
         if string.find(n, parami, 1, true) then
            minetest.chat_send_player(name, n)
         end
      end

   end,
})

--can be useful in combination with unknown items from which you want to know what they are.
core.register_chatcommand("pwii", {
   description = "print wielded item",
   params = "",
   privs = {},
   func = function(name, param)
      local player_sao=minetest.get_player_by_name(name)
      local wielditem=player_sao:get_wielded_item()
      if not wielditem then return true, "PWII: No Item" end
      return true, "PWII: "..wielditem:get_name().." "..wielditem:get_count()
   end,
})

--pure get_player_information call
core.register_chatcommand("pinfo", {
   description = "print info about player",
   params = "player_name",
   privs = {server=true},
   func = function(name, param)
      return true, param.." -> "..dump(minetest.get_player_information(param)) or "No player or serialisation failed."
   end,
})

--2 tools that make life easier
minetest.register_tool("morecommands:admintool", {
   description = "Admin tool. Left click object/node: remove without any check. Right click node: remove node ad adjacent position (useful for non-pointable nodes)",
   inventory_image = "default_tool_woodaxe",
   groups={not_in_creative_inventory=1},
   on_use = function(itemstack, user, pointed_thing)
      if not user then return end
      local has_privs, missing_privs = core.check_player_privs(user:get_player_name(), {server=true})
      if not has_privs then
         minetest.chat_send_player(user:get_player_name(), "You are a cheater!")
         return itemstack:take_item()
      end

      if pointed_thing.type == "node" then
         if pointed_thing.under then
            minetest.set_node(pointed_thing.under, {name="air"})
         end
      elseif pointed_thing.type == "object" then
         if pointed_thing.ref then
            pointed_thing.ref:remove()
         end
      end
      return itemstack
   end,
   on_place = function(itemstack, user, pointed_thing)
      if not user then return end

      local has_privs, missing_privs = core.check_player_privs(user:get_player_name(), {server=true})
      if not has_privs then
         minetest.chat_send_player(user:get_player_name(), "You are a cheater!")
         return itemstack:take_item()
      end

      if pointed_thing.type == "node" then
         if pointed_thing.above then
            minetest.set_node(pointed_thing.above, {name="air"})
         end
      end
      return itemstack
   end,
})
minetest.register_tool("morecommands:infotool", {
   description = "Info tool. Left click node to get information.",
   inventory_image = "farming_tool_woodhoe.png",
   groups={not_in_creative_inventory=1},
   on_use = function(itemstack, user, pointed_thing)
      if not user then return end
      local has_privs, missing_privs = core.check_player_privs(user:get_player_name(), {server=true})
      if not has_privs then
         minetest.chat_send_player(user:get_player_name(), "You are a cheater!")
         return itemstack:take_item()
      end
      
      if pointed_thing.type == "node" then
         if pointed_thing.under then
            minetest.chat_send_player(user:get_player_name(), "Node at "..minetest.pos_to_string(pointed_thing.under)..": "..(dump(minetest.get_node_or_nil(pointed_thing.under))))
            return itemstack
         end
      end
      return itemstack
   end,
})

--formspec broadcaster
core.register_chatcommand("broadcast", {
   description = "open broadcasting formspec with a huge text area. have fun while typing in text.",
   params = "<text>",
   privs = {server=true},
   func = function(name, param)
      print(name.." broadcasted "..param)
      for _, objref in pairs(minetest.get_connected_players()) do
         minetest.show_formspec(objref:get_player_name(), "broadcast", "size[11,10]textarea[0.5,0.5;10.5,10;maintext;Broadcast message from "..name..";"..param.."]button_exit[4,9;4,1;end;OK]")
      end
   end,
})
--formspec broadcaster
core.register_chatcommand("showtext", {
   description = "open formspec with a huge text area at player. have fun while typing in text.",
   params = "<player> <text>",
   privs = {server=true},
   func = function(name, param)
      local key,val=string.match(param, "^([^%s]+)%s?(.*)$")
      if minetest.get_player_by_name(key) then
         minetest.show_formspec(key, "broadcast", "size[11,10]textarea[0.5,0.5;10.5,10;maintext;;"..val.."]button_exit[4,9;4,1;end;OK]")
      end
   end,
})

--get/set metadata. TODO: improve, atm they use the stand-pos of the player
core.register_chatcommand("getmeta", {
   params = "<key>",
   description = "get metadata of underlying node",
   privs = {server=true},
   func = function(name, param)
      local posi=core.get_player_by_name(name):getpos()
      posi.x=math.floor(posi.x+0.5)
      posi.y=math.floor(posi.y+1)
      posi.z=math.floor(posi.z+0.5)
      local meta=minetest.get_meta(posi)
      if meta then
         local prev="<not set>"
         if meta:get_string(param) and meta:get_string(param)~="" then
            prev=meta:get_string(param)
         end
         return true,param.." of "..minetest.pos_to_string(posi)..": "..prev
      end
      return false,"No metadata at "..minetest.pos_to_string(posi)
   end,
})

core.register_chatcommand("setmeta", {
   params = "<key> <value>",
   description = "set meta of underlying node",
   privs = {server=true},
   func = function(name, param)
      local key,val=string.match(param, "^([^%s]+)%s?(.*)$")
      if not key or not val then
         return false,"invalid parameters!"
      end
      local posi=core.get_player_by_name(name):getpos()
      posi.x=math.floor(posi.x+0.5)
      posi.y=math.floor(posi.y+1)
      posi.z=math.floor(posi.z+0.5)
      local meta=minetest.get_meta(posi)
      if meta then
         local prev="<not set>"
         if meta:get_string(key) and meta:get_string(key)~="" then
            prev=meta:get_string(key)
         end
         meta:set_string(key, val or "")
         return true,"Set "..key.." of node "..minetest.pos_to_string(posi).." to "..val..". Previous value: "..prev
      end
      return false,"No metadata at "..minetest.pos_to_string(posi)
   end,
})
core.register_chatcommand("dumpmeta", {
   params = "",
   description = "dump meta of underlying node",
   privs = {server=true},
   func = function(name, param)
   local posi=core.get_player_by_name(name):getpos()
   posi.x=math.floor(posi.x+0.5)
   posi.y=math.floor(posi.y+1)
   posi.z=math.floor(posi.z+0.5)
   local meta=minetest.get_meta(posi)
   if meta then
      return true,dump(meta:to_table())
   end
   return false,"No metadata at "..minetest.pos_to_string(posi)
end,
})

--register command aliases:
--introduce some short names for commands you use often
morecmds_rca=function(name, from)
   if minetest.chatcommands[from] then
      minetest.register_chatcommand(name, minetest.chatcommands[from])
   end
end
minetest.after(0,function()
morecmds_rca("tp", "teleport")
morecmds_rca("gm", "giveme")
morecmds_rca("g", "give")
morecmds_rca("i", "giveme")
morecmds_rca("sd", "shutdown")
morecmds_rca("il", "ilist")
morecmds_rca("l", "list")
morecmds_rca("ki", "kick")
morecmds_rca("b", "ban")
morecmds_rca("ub", "unban")
morecmds_rca("bc", "broadcast")
morecmds_rca("pv", "pulverize")
morecmds_rca("gt", "grant")
morecmds_rca("rv", "revoke")
morecmds_rca("h", "heal")
morecmds_rca("k", "kill")
morecmds_rca("co", "clearobjects")
morecmds_rca("s", "spawn")
morecmds_rca("sp", "spawnpoint")
morecmds_rca("stop", "shutdown")
morecmds_rca("v", "vanish")
morecmds_rca("c", "clear")
morecmds_rca("p", "pulverize")
morecmds_rca("u", "up")
morecmds_rca("d", "down")
end)
