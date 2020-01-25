-- skin mods support

local skin_mods = {"skins", "u_skins", "simple_skins", "wardrobe"}
for _, mod in pairs(skin_mods) do
    local path = minetest.get_modpath(mod)
    if path then
        local dir_list = minetest.get_dir_list(path.."/textures")
        for _, fn in pairs(dir_list) do
            if fn:find("_preview.png$") then
                armor:add_preview(fn)
            end
        end
        armor.skin_mod = mod
    end
end

if armor.skin_mod then
    armor.get_player_skin = function(self, name)
        if (self.skin_mod == "skins" or self.skin_mod == "simple_skins") and skins.skins[name] then
            return skins.skins[name]..".png"
        elseif self.skin_mod == "u_skins" and u_skins.u_skins[name] then
            return u_skins.u_skins[name]..".png"
        elseif self.skin_mod == "wardrobe" and wardrobe.playerSkins and wardrobe.playerSkins[name] then
            return wardrobe.playerSkins[name]
        end
        return self:get_default_skin(name)
    end
end
