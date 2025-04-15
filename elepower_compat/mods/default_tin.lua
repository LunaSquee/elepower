local epg = ele.external.graphic
local eps = ele.external.sounds
local epi = ele.external.ing
local ingot = "elepower_dynamics:tin_ingot"

if epi.tin_ingot == "" then
    epi.tin_ingot = ingot

    core.register_craftitem(":elepower_dynamics:tin_ingot", {
        description = "Tin Ingot",
        inventory_image = "elepower_tin_ingot.png",
        groups = {tin = 1, ingot = 1}
    })

    core.register_craftitem(":elepower_dynamics:tin_lump", {
        description = "Tin Lump",
        inventory_image = "elepower_tin_lump.png",
        groups = {tin = 1, lump = 1}
    })

    core.register_node(":elepower_dynamics:stone_with_tin", {
        description = "Tin Ore",
        tiles = {epg.stone .. "^elepower_mineral_tin.png"},
        groups = {cracky = 2, pickaxey = 3, material_stone = 1},
        drop = 'elepower_dynamics:tin_lump',
        sounds = eps.node_sound_stone,
        _mcl_blast_resistance = 3,
        _mcl_hardness = 3,
        _mcl_silk_touch_drop = true,
    })

    core.register_node(":elepower_dynamics:tin_block", {
        description = "Tin Block",
        tiles = {"elepower_tin_block.png"},
        is_ground_content = false,
        groups = {cracky = 1, level = 2},
        sounds = eps.node_sound_metal
    })

    core.register_craft({
        type = "cooking",
        output = ingot,
        recipe = "elepower_dynamics:tin_lump"
    })

    core.register_craft({
        output = "elepower_dynamics:tin_block",
        recipe = {
            {ingot, ingot, ingot}, {ingot, ingot, ingot}, {ingot, ingot, ingot}
        }
    })

    core.register_craft({
        output = ingot .. " 9",
        recipe = {{"elepower_dynamics:tin_block"}}
    })

    if core.get_modpath("mcl_core") == nil then
        ele.worldgen.ore.tin = {
            high = {
                clust_scarcity = 10 ^ 3,
                clust_num_ores = 4,
                clust_size = 3,
                y_max = 31000,
                y_min = 1025
            },
            normal = {
                clust_scarcity = 13 ^ 3,
                clust_num_ores = 2,
                clust_size = 3,
                y_max = -32,
                y_min = -127
            },
            deep = {
                clust_scarcity = 10 ^ 3,
                clust_num_ores = 4,
                clust_size = 3,
                y_max = -128,
                y_min = -31000
            }
        }
    else
        ele.worldgen.ore.tin = {
            high = {
                clust_scarcity = 10 ^ 3,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = -10,
                y_max = 0
            },
            normal = {
                clust_scarcity = 13 ^ 3,
                clust_num_ores = 2,
                clust_size = 3,
                y_min = -57,
                y_max = -8
            },
            deep = {
                clust_scarcity = 10 ^ 3,
                clust_num_ores = 4,
                clust_size = 3,
                y_min = -31000,
                y_max = -128
            }
        }
    end
else
    core.register_alias("elepower_dynamics:tin_ingot",
                        ele.external.ing.tin_ingot)
end
