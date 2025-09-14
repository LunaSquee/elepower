-- An Elepower Mod
-- Copyright 2018 Evert "Diamond" Prants <evert@lunasqu.ee>

local modpath = minetest.get_modpath(minetest.get_current_modname())
local ele_compat = core.get_modpath("elepower_compat") ~= nil

ele = rawget(_G, "ele") or {}
ele.api_standalone = not ele_compat
ele.modpath = modpath
ele.translator = ele.translator or core.get_translator("elepower_papi")

-- Constants
ele.unit = "EpU"
ele.unit_description = "Elepower Unit"

-- Standalone version compatibility fill-ins
if ele.api_standalone then
  dofile(modpath..'/compat.lua')
end

-- APIs
dofile(modpath..'/helpers.lua')
dofile(modpath..'/network.lua')
dofile(modpath..'/formspec.lua')
dofile(modpath..'/machine.lua')
dofile(modpath..'/conductor.lua')
dofile(modpath..'/tool.lua')
