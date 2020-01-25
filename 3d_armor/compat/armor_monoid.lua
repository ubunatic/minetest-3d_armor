-- armor_monoids support

if minetest.global_exists("armor_monoid") then
    armor.use_armor_monoid = true
    print("[3d_armor] Using armor_monoid mod")
else
    print("[3d_armor] Not using armor_monoid mod")
end
