-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epi = ele.external.ing

--------------
-- Worldgen --
--------------

-- Uranium
local uranium = ele.worldgen.ore._uranium

minetest.register_ore(ele.helpers.merge_tables({
    ore_type = "scatter",
    ore = "elepower_nuclear:stone_with_uranium",
    wherein = epi.stone
}, uranium.high))

minetest.register_ore(ele.helpers.merge_tables({
    ore_type = "scatter",
    ore = "elepower_nuclear:stone_with_uranium",
    wherein = epi.stone
}, uranium.normal))

minetest.register_ore(ele.helpers.merge_tables({
    ore_type = "scatter",
    ore = "elepower_nuclear:stone_with_uranium",
    wherein = epi.stone
}, uranium.deep))
