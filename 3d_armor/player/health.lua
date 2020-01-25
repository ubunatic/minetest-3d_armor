
if armor.config.punch_damage == true then
	minetest.register_on_punchplayer(function(player, hitter,
			time_from_last_punch, tool_capabilities)
		local name = player:get_player_name()
		if name then
			armor:punch(player, hitter, time_from_last_punch, tool_capabilities)
			armor.last_punch_time[name] = minetest.get_gametime()
		end
	end)
end

minetest.register_on_player_hpchange(function(player, hp_change)
	if player and hp_change < 0 then
		local name = player:get_player_name()
		if name then
			local heal = armor.def[name].heal
			if heal >= math.random(100) then
				hp_change = 0
			end
			-- check if armor damage was handled by fire or on_punchplayer
			local time = armor.last_punch_time[name] or 0
			if time == 0 or time + 1 < minetest.get_gametime() then
				armor:punch(player)
			end
		end
	end
	return hp_change
end, true)