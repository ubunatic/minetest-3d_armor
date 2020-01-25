-- load config from minetest settings

for name, config in pairs(armor.config) do
    local setting = minetest.settings:get("armor_"..name)
    if type(config) == "number" then
        setting = tonumber(setting)
    elseif type(config) == "boolean" then
        setting = minetest.settings:get_bool("armor_"..name)
    end
    if setting ~= nil then
        armor.config[name] = setting
    end
end
for material, _ in pairs(armor.materials) do
    local key = "material_"..material
    if armor.config[key] == false then
        armor.materials[material] = nil
    end
end
