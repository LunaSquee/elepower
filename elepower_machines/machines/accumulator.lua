-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epi = ele.external.ing
local S = ele.translator

local CAPACITY = 8000

minetest.register_node("elepower_machines:accumulator", {
    description = S("Water Accumulator"),
    groups = {
        fluid_container = 1,
        oddly_breakable_by_hand = 1,
        cracky = 3,
        pickaxey = 1
    },
    tiles = {
        "elepower_machine_top.png^elepower_power_port.png",
        "elepower_machine_base.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png"
    },
    fluid_buffers = {water = {capacity = CAPACITY, drainable = true}},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("water_fluid", epi.water_source)
    end
})

minetest.register_node("elepower_machines:accumulator_heavy", {
    description = S("Water Accumulator") .. " (" .. S("Heavy Water") .. ")",
    groups = {
        fluid_container = 1,
        oddly_breakable_by_hand = 1,
        cracky = 3,
        pickaxey = 1,
        not_in_creative_inventory = 1
    },
    tiles = {
        "elepower_machine_top.png^elepower_power_port.png",
        "elepower_machine_base.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png",
        "elepower_machine_side.png^elepower_machine_accumulator.png"
    },
    drop = {
        max_items = 2,
        items = {
            {
                items = {
                    "elepower_machines:accumulator",
                    "elepower_machines:heavy_filter"
                },
                rarity = 1
            }
        }
    },
    fluid_buffers = {water = {capacity = CAPACITY, drainable = true}},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("water_fluid", "elepower_nuclear:heavy_water_source")
    end,
    _heavy = true
})

minetest.register_abm({
    nodenames = {
        "elepower_machines:accumulator", "elepower_machines:accumulator_heavy"
    },
    label = "elefluidAccumulator",
    interval = 2,
    chance = 1 / 5,
    action = function(pos, node)
        local meta = minetest.get_meta(pos)
        local buffer = fluid_lib.get_buffer_data(pos, "water")
        if not buffer or buffer.amount == buffer.capacity then return end

        local positions = {
            {x = pos.x + 1, y = pos.y, z = pos.z},
            {x = pos.x - 1, y = pos.y, z = pos.z},
            {x = pos.x, y = pos.y, z = pos.z + 1},
            {x = pos.x, y = pos.y, z = pos.z - 1}
        }

        local amount = 0
        for _, fpos in pairs(positions) do
            local source = minetest.get_node(fpos)
            if source.name == epi.water_source then
                amount = amount + 1000
            end
        end

        if amount == 0 then
            meta:set_string("infotext", "Submerge me in water!")
            return
        end

        local ndef = minetest.registered_nodes[node.name]
        local src = epi.water_source
        if ndef and ndef._heavy then
            src = "elepower_nuclear:heavy_water_source"
            if amount > 1000 then amount = math.floor(amount / 8) end
        end

        local give = 0
        if buffer.amount + amount > buffer.capacity then
            give = buffer.capacity - buffer.amount
        else
            give = amount
        end

        buffer.amount = buffer.amount + give

        meta:set_int("water_fluid_storage", buffer.amount)
        meta:set_string("water_fluid", src)
        meta:set_string("infotext", fluid_lib.buffer_to_string(buffer))
    end
})

fluid_lib.register_node("elepower_machines:accumulator")
fluid_lib.register_node("elepower_machines:accumulator_heavy")
