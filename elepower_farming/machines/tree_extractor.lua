-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epi = ele.external.ing
local S = ele.translator

local CAPACITY = 8000

-- TODO: Better game support, currently very much hardcoded
local fluid_table = {
    [epi.tree] = {fpc = 100, fluid = "elepower_farming:tree_sap_source"},
    [epi.jungle_tree] = {fpc = 50, fluid = "elepower_farming:resin_source"},
    [epi.pine_tree] = {fpc = 100, fluid = "elepower_farming:resin_source"},
    [epi.acacia_tree] = {fpc = 50, fluid = "elepower_farming:resin_source"},
    [epi.aspen_tree] = {fpc = 50, fluid = "elepower_farming:resin_source"}
}

minetest.register_node("elepower_farming:tree_extractor", {
    description = S("Tree Fluid Extractor"),
    groups = {
        fluid_container = 1,
        oddly_breakable_by_hand = 1,
        cracky = 3,
        pickaxey = 1
    },
    tiles = {
        "elefarming_machine_base.png", "elefarming_machine_base.png",
        "elefarming_machine_side.png", "elefarming_machine_side.png",
        "elefarming_machine_side.png^elepower_power_port.png",
        "elefarming_machine_tree_extractor.png"
    },
    fluid_buffers = {tree = {capacity = CAPACITY}},
    paramtype2 = "facedir",
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2
})

minetest.register_abm({
    nodenames = {"elepower_farming:tree_extractor"},
    label = "elefluidSapAccumulator",
    interval = 8,
    chance = 1 / 6,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local meta = minetest.get_meta(pos)
        local buffer = fluid_lib.get_buffer_data(pos, "tree")
        if not buffer or buffer.amount == buffer.capacity then return end

        local fpos = ele.helpers.face_front(pos, node.param2)
        local amount = 0
        local ftype = buffer.fluid
        local fnode = minetest.get_node_or_nil(fpos)
        if fnode and ele.helpers.get_item_group(fnode.name, "tree") then
            local fdata = fluid_table[fnode.name]
            if fdata and (ftype == "" or ftype == fdata.fluid) then
                amount = fdata.fpc
                ftype = fdata.fluid
            end
        end

        if amount == 0 then
            meta:set_string("infotext", S("Place me in front of a tree!"))
            return
        end

        local give = 0
        if buffer.amount + amount > buffer.capacity then
            give = buffer.capacity - buffer.amount
        else
            give = amount
        end

        buffer.amount = buffer.amount + give
        buffer.fluid = ftype

        meta:set_int("tree_fluid_storage", buffer.amount)
        meta:set_string("tree_fluid", buffer.fluid)
        meta:set_string("infotext", fluid_lib.buffer_to_string(buffer))
    end
})

fluid_lib.register_node("elepower_farming:tree_extractor")
