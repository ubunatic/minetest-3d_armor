-- armor_monoids support
local S = armor_i18n.gettext

if minetest.global_exists("armor_monoid") then
    armor.use_armor_monoid = true
    print(S("[3d_armor] Using armor_monoid mod"))
else
    print(S("[3d_armor] Not using armor_monoid mod"))
end
