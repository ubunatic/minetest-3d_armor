local S = armor_i18n.gettext

local pending_players = {}
local timer = 0

armor:register_on_destroy(function(player, index, stack)
	local name = player:get_player_name()
	local def = stack:get_definition()
	if name and def and def.description then
		minetest.chat_send_player(name, S("Your @1 got destroyed!", def.description))
	end
end)

local function init_player_armor(player)
	local name = player:get_player_name()
	local pos = player:get_pos()
	if not name or not pos then
		return false
	end
	local armor_inv = minetest.create_detached_inventory(name.."_armor", {
		on_put = function(inv, listname, index, stack, player)
			armor:validate_and_save_inventory(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			armor:validate_and_save_inventory(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			armor:validate_and_save_inventory(player)
		end,
		allow_put = function(inv, listname, index, put_stack, player)
			local element = armor:get_element(put_stack:get_name())
			if not element then
				return 0
			end
			for i = 1, 6 do
				local stack = inv:get_stack("armor", i)
				local def = stack:get_definition() or {}
				if def.groups and def.groups["armor_"..element]
						and i ~= index then
					return 0
				end
			end
			return 1
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
	}, name)
	armor_inv:set_size("armor", 6)
	if not armor:load_armor_inventory(player) and armor.migrate_old_inventory then
		local player_inv = player:get_inventory()
		player_inv:set_size("armor", 6)
		for i=1, 6 do
			local stack = player_inv:get_stack("armor", i)
			armor_inv:set_stack("armor", i, stack)
		end
		armor:save_armor_inventory(player)
		player_inv:set_size("armor", 0)
	end
	for i=1, 6 do
		local stack = armor_inv:get_stack("armor", i)
		if stack:get_count() > 0 then
			armor:run_callbacks("on_equip", player, i, stack)
		end
	end
	armor.def[name] = {
		init_time = minetest.get_gametime(),
		level = 0,
		state = 0,
		count = 0,
		groups = {},
	}
	for _, phys in pairs(armor.physics) do
		armor.def[name][phys] = 1
	end
	for _, attr in pairs(armor.attributes) do
		armor.def[name][attr] = 0
	end
	for group, _ in pairs(armor.registered_groups) do
		armor.def[name].groups[group] = 0
	end
	local skin = armor:get_player_skin(name)
	armor.textures[name] = {
		skin = skin,
		armor = "3d_armor_trans.png",
		wielditem = "3d_armor_trans.png",
		preview = armor.default_skin.."_preview.png",
	}
	local texture_path = minetest.get_modpath("player_textures")
	if texture_path then
		local dir_list = minetest.get_dir_list(texture_path.."/textures")
		for _, fn in pairs(dir_list) do
			if fn == "player_"..name..".png" then
				armor.textures[name].skin = fn
				break
			end
		end
	end
	armor:set_player_armor(player)
	return true
end

default.player_register_model("3d_armor_character.b3d", {
	animation_speed = 30,
	textures = {
		armor.default_skin..".png",
		"3d_armor_trans.png",
		"3d_armor_trans.png",
	},
	animations = {
		stand = {x=0, y=79},
		lay = {x=162, y=166},
		walk = {x=168, y=187},
		mine = {x=189, y=198},
		walk_mine = {x=200, y=219},
		sit = {x=81, y=160},
	},
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = armor:get_valid_player(player, "[on_player_receive_fields]")
	if not name then
		return
	end
	for field, _ in pairs(fields) do
		if string.find(field, "skins_set") then
			minetest.after(0, function(player)
				local skin = armor:get_player_skin(name)
				armor.textures[name].skin = skin
				armor:set_player_armor(player)
			end, player)
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	default.player_set_model(player, "3d_armor_character.b3d")
	minetest.after(0, function(player)
		if init_player_armor(player) == false then
			pending_players[player] = 0
		end
	end, player)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		armor.def[name] = nil
		armor.textures[name] = nil
	end
	pending_players[player] = nil
end)

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > armor.config.init_delay then
		for player, count in pairs(pending_players) do
			local remove = init_player_armor(player) == true
			pending_players[player] = count + 1
			if remove == false and count > armor.config.init_times then
				minetest.log("warning", S("3d_armor: Failed to initialize player"))
				remove = true
			end
			if remove == true then
				pending_players[player] = nil
			end
		end
		timer = 0
	end
end)