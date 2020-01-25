-- legacy config support
local modpath = minetest.get_modpath(minetest.get_current_modname())
local worldpath = minetest.get_worldpath()

local input = io.open(modpath.."/armor.conf", "r")
if input then
    dofile(modpath.."/armor.conf")
    input:close()
    input = nil
end
input = io.open(worldpath.."/armor.conf", "r")
if input then
    dofile(worldpath.."/armor.conf")
    input:close()
    input = nil
end
for name, _ in pairs(armor.config) do
    local global = "ARMOR_"..name:upper()
    if minetest.global_exists(global) then
        armor.config[name] = _G[global]
    end
end
if minetest.global_exists("ARMOR_MATERIALS") then
    armor.materials = table.copy(ARMOR_MATERIALS)
end
if minetest.global_exists("ARMOR_FIRE_NODES") then
    armor.fire_nodes = table.copy(ARMOR_FIRE_NODES)
end
