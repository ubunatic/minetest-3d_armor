-- pova support
local S = armor_i18n.gettext

if minetest.get_modpath("pova") then
    armor.use_pova_mod = true
    print(S("[3d_armor] Using pova mod"))
    armor.set_player_physics_override = function (self, player, name, physics)
        -- only add the changes, not the default 1.0 for each physics setting
        pova.add_override(name, "3d_armor", {
            speed = physics.speed - 1,
            jump = physics.jump - 1,
            gravity = physics.gravity - 1,
        })
        pova.do_override(player)
    end
else
    print(S("[3d_armor] Not using pova mod"))
end