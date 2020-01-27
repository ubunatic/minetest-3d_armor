
local validate_armor_inventory = function(player)
	-- Workaround for detached inventory swap exploit
	local _, inv = armor:get_valid_player(player, "[validate_armor_inventory]")
	if not inv then
		return
	end
	local armor_prev = {}
	local armor_list_string = player:get_meta():get("3d_armor_inventory")
	if armor_list_string then
		local armor_list = armor:deserialize_inventory_list(armor_list_string)
		for i, stack in ipairs(armor_list) do
			if stack:get_count() > 0 then
				armor_prev[stack:get_name()] = i
			end
		end
	end
	local elements = {}
	local player_inv = player:get_inventory()
	for i = 1, 6 do
		local stack = inv:get_stack("armor", i)
		if stack:get_count() > 0 then
			local item = stack:get_name()
			local element = armor:get_element(item)
			if element and not elements[element] then
				if armor_prev[item] then
					armor_prev[item] = nil
				else
					-- Item was not in previous inventory
					armor:run_callbacks("on_equip", player, i, stack)
				end
				elements[element] = true;
			else
				inv:remove_item("armor", stack)
				-- The following code returns invalid items to the player's main
				-- inventory but could open up the possibity for a hacked client
				-- to receive items back they never really had. I am not certain
				-- so remove the is_singleplayer check at your own risk :]
				if minetest.is_singleplayer() and player_inv and
						player_inv:room_for_item("main", stack) then
					player_inv:add_item("main", stack)
				end
			end
		end
	end
	for item, i in pairs(armor_prev) do
		local stack = ItemStack(item)
		-- Previous item is not in current inventory
		armor:run_callbacks("on_unequip", player, i, stack)
	end
end

armor.validate_and_save_inventory = function(self, player)
	validate_armor_inventory(player)
	self:save_armor_inventory(player)
	self:set_player_armor(player)
end