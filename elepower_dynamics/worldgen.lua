
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref

--------------
-- Worldgen --
--------------

-- see elepower_compat >> worldgen.lua for definitions

for mat, defs in pairs(ele.worldgen.ore) do
	for _, scatter in pairs(defs) do
		core.register_ore(
			ele.helpers.merge_tables(
				{
					ore_type       = "scatter",
					ore            = "elepower_dynamics:stone_with_" .. mat,
					wherein        = epr.stone,
				}, scatter
			)
		)
	end
end
