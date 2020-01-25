local modpath = minetest.get_modpath(minetest.get_current_modname())

-- Support for i18n

armor_i18n = {}
armor_i18n.gettext, armor_i18n.ngettext = dofile(modpath.."/intllib.lua")
local S = armor_i18n.gettext
local F = minetest.formspec_escape

-- Init Module and Load Config

dofile(modpath.."/api/api.lua")
dofile(modpath.."/compat/legacy_config.lua")
dofile(modpath.."/api/config.lua")

-- Mod Compatibility

dofile(modpath.."/compat/skin_mods.lua")

-- Simple Mod Compatibility

if not minetest.get_modpath("moreores") then
	armor.materials.mithril = nil
end
if not minetest.get_modpath("ethereal") then
	armor.materials.crystal = nil
end

if minetest.get_modpath("technic") then
	armor:register_armor_group("radiation")
	armor.formspec = armor.formspec..armor.formspec_technic
end
if armor.config.fire_protect then
	armor.formspec = armor.formspec..armor.formspec_fire
end

-- Armor Initialization

dofile(modpath.."/armor.lua")
dofile(modpath.."/api/validate.lua")

-- Register Event Handlers

dofile(modpath.."/player/register.lua")
dofile(modpath.."/player/health.lua")
dofile(modpath.."/player/death.lua")
dofile(modpath.."/player/protect.lua")