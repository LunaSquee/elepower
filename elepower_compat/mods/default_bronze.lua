local eps = ele.external.sounds
local epi = ele.external.ing
local ingot = "elepower_dynamics:bronze_ingot"

if epi.bronze_ingot == "" then
    epi.bronze_ingot = ingot

    core.register_craftitem(":elepower_dynamics:bronze_ingot", {
        description = "Bronze Ingot",
        inventory_image = "elepower_bronze_ingot.png",
        groups = {bronze = 1, ingot = 1}
    })

    core.register_node(":elepower_dynamics:bronze_block", {
        description = "Bronze Block",
        tiles = {"elepower_bronze_block.png"},
        is_ground_content = false,
        groups = {cracky = 1, pickaxey = 2, level = 2},
        sounds = eps.node_sound_metal
    })

    core.register_craft({
        output = "elepower_dynamics:bronze_block",
        recipe = {
            {ingot, ingot, ingot}, {ingot, ingot, ingot}, {ingot, ingot, ingot}
        }
    })

    core.register_craft({
        output = ingot .. " 9",
        recipe = {{"elepower_dynamics:bronze_block"}}
    })
else
    core.register_alias("elepower_dynamics:bronze_ingot",
                        ele.external.ing.bronze_ingot)
end
