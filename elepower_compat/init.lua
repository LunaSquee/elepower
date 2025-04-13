local modpath = minetest.get_modpath(minetest.get_current_modname())

ele = rawget(_G, "ele") or {}

-- Setup globals
dofile(modpath.."/external.lua")
dofile(modpath.."/worldgen.lua")

-- Games support
dofile(modpath.."/mods/mtg_default.lua")
dofile(modpath.."/mods/mcl_core.lua")

-- Mod substitutions
dofile(modpath.."/mods/basic_materials.lua")
dofile(modpath.."/mods/moreores.lua")
