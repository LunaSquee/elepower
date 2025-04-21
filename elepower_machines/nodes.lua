local S = ele.translator

-- Nodes other than machines.

minetest.register_node("elepower_machines:machine_block", {
    description = S("Machine Block") .. "\n" .. S("Safe for decoration"),
    tiles = {
        "elepower_machine_top.png", "elepower_machine_base.png",
        "elepower_machine_side.png"
    },
    groups = {oddly_breakable_by_hand = 1, cracky = 3, pickaxey = 1},
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2
})

minetest.register_node("elepower_machines:heat_casing", {
    description = S("Heat Casing") .. "\n" ..
        S("Used for the Thermal Evaporation Plant") .. "\n" ..
        S("Safe for decoration"),
    tiles = {"elepower_heat_casing.png"},
    groups = {cracky = 2, pickaxey = 2, ele_evaporator_node = 1},
    _mcl_blast_resistance = 4,
    _mcl_hardness = 4
})

minetest.register_node("elepower_machines:advanced_machine_block", {
    description = S("Advanced Machine Block") .. "\n" ..
        S("Safe for decoration"),
    tiles = {"elepower_advblock_combined.png"},
    groups = {cracky = 2, pickaxey = 2},
    _mcl_blast_resistance = 3,
    _mcl_hardness = 3
})
