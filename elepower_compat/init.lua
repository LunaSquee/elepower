local modpath = minetest.get_modpath(minetest.get_current_modname())

ele = rawget(_G, "ele") or {}
ele.translator = core.get_translator("elepower")

--- Nest a value in given table, varargs should contain the path to dig down and the last
--- arg should be the value to set.
---
--- @spec put_in_new(self: Table, ...: Any[]): void
function ele.put_in_new(self, ...)
  local len = select("#", ...)
  if len >= 2 then
    local pathlen = len - 2
    local root = self
    if pathlen > 0 then
      local key
      for i = 1,pathlen do
        key = select(i, ...)
        if root[key] == nil then
          root[key] = {}
        end
        root = root[key]
        if type(root) ~= "table" then
          error("cannot put_in_new with non-table")
        end
      end
    end
    local key = select(len - 1, ...)
    local value = select(len, ...)
    if root[key] == nil then
      root[key] = value
    end
  else
    error("there must be at least two values, a key and value (got " .. len .. ")")
  end
end

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
