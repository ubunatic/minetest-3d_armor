-- player_monoids support
local S = armor_i18n.gettext

if minetest.global_exists("player_monoids") then
    armor.use_player_monoids = true
    print(S("[3d_armor] Using player_monoids mod"))
    if not player_monoids.make_monoid then
        player_monoids.make_monoid = player_monoids.monoid
        print(S("[3d_armor] Monkeypatched player_monoids to fix potentially broken armor_monoid"))
    end
    armor.set_player_physics_override = function(self, player, name, physics)
        print(S("player_monoids physics override"))
        player_monoids.speed:add_change(player, physics.speed,
        "3d_armor:physics")
        player_monoids.jump:add_change(player, physics.jump,
        "3d_armor:physics")
        player_monoids.gravity:add_change(player, physics.gravity,
        "3d_armor:physics")
    end
else
    print(S("[3d_armor] Not using player_monoids mod"))
end
