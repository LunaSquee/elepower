-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epi = ele.external.ing
local S = ele.translator

ele.register_fluid_generator("elepower_machines:lava_generator", {
    description = S("Lava Generator"),
    ele_usage = 64,
    tiles = {
        "elepower_machine_top.png", "elepower_machine_base.png",
        "elepower_machine_side.png", "elepower_machine_side.png",
        "elepower_machine_side.png",
        "elepower_machine_side.png^elepower_lava_generator.png"
    },
    ele_active_node = true,
    ele_active_nodedef = {
        tiles = {
            "elepower_machine_top.png", "elepower_machine_base.png",
            "elepower_machine_side.png", "elepower_machine_side.png",
            "elepower_machine_side.png",
            "elepower_machine_side.png^elepower_lava_generator_active.png"
        }
    },
    fluid_buffers = {
        lava = {capacity = 8000, accepts = {epi.lava_source}, drainable = false}
    },
    tube = false
})
