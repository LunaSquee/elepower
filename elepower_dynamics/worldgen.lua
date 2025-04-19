-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epi = ele.external.ing

--------------
-- Worldgen --
--------------

-- see elepower_compat >> worldgen.lua for definitions

for mat, defs in pairs(ele.worldgen.ore) do
	-- Underscore name means it is not generated in dynamics
    if defs ~= nil and mat:sub(1, 1) ~= "_" then
        for _, noise_params in pairs(defs) do
            core.register_ore(ele.helpers.merge_tables({
                ore_type = "scatter",
                ore = "elepower_dynamics:stone_with_" .. mat,
                wherein = epi.stone
            }, noise_params))
        end
    end
end
