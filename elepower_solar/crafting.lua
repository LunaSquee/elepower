-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epi = ele.external.ing

-- Solar Generator
minetest.register_craft({
    output = "elepower_solar:solar_generator",
    recipe = {
        {epi.glass, "elepower_dynamics:pv_cell", epi.glass},
        {"elepower_dynamics:pv_cell", epi.glass, "elepower_dynamics:pv_cell"}, {
            "elepower_dynamics:steel_ingot", "elepower_dynamics:battery",
            "elepower_dynamics:steel_ingot"
        }
    }
})
