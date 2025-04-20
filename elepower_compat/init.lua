local modpath = minetest.get_modpath(minetest.get_current_modname())

ele = rawget(_G, "ele") or {}

-- Setup globals
dofile(modpath.."/external.lua")
dofile(modpath.."/worldgen.lua")

-- Games support
dofile(modpath.."/games/mtg_default.lua")
dofile(modpath.."/games/mcl_core.lua")

-- Overrides by xcompat
dofile(modpath.."/mods/xcompat.lua")

-- Overrides by settings
dofile(modpath.."/overrides.lua")

-- Mod substitutions
dofile(modpath.."/mods/moreores.lua")
dofile(modpath.."/mods/default_tin.lua")
dofile(modpath.."/mods/default_bronze.lua")
dofile(modpath.."/mods/basic_materials.lua")
