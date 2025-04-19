local mcl = core.get_modpath("mcl_farming")

-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local eps = ele.external.sounds
local epi = ele.external.ing
local efs = ele.formspec

-- How many seconds there are between runs
local PLANTER_TICK = 10

-- Growth regions for configured crops
local ranges = {
    -- Slot 1 (starts from upper left corner)
    {{x = -4, z = 2, y = 1}, {x = -2, z = 4, y = 1}}, -- Slot 2
    {{x = -1, z = 2, y = 1}, {x = 1, z = 4, y = 1}}, -- Slot 3
    {{x = 2, z = 2, y = 1}, {x = 4, z = 4, y = 1}}, -- Slot 4
    {{x = -4, z = -1, y = 1}, {x = -2, z = 1, y = 1}}, -- Slot 5 (center)
    {{x = -1, z = -1, y = 1}, {x = 1, z = 1, y = 1}}, -- Slot 6
    {{x = 2, z = -1, y = 1}, {x = 4, z = 1, y = 1}}, -- Slot 7
    {{x = -4, z = -4, y = 1}, {x = -2, z = -2, y = 1}}, -- Slot 8
    {{x = -1, z = -4, y = 1}, {x = 1, z = -2, y = 1}},
    -- Slot 9 (last one, bottom right)
    {{x = 2, z = -4, y = 1}, {x = 4, z = -2, y = 1}}
}

local function get_formspec(timer, power, state)
    local layout_w, layout_h = efs.get_list_size(3, 3)
    local src_w, src_h = efs.get_list_size(8, 2)
    local layout_x = efs.center_in_box(11.75, 12.45, layout_w, layout_h)
    local layout = efs.slot_grid(layout_x, 0.375, 3, 3)
    local start, bx, by, mx = efs.begin(11.75, 12.45)

    local layout_tt = "Item placed here\n  will be planted\nout in a 3x3 area"
    local layout_bi = "elepower_planter_layout.png"

    return start .. efs.power_meter(power) ..
               efs.state_switcher(mx - 1, by, state) ..
               efs.create_bar(bx + 1.25, by, 100 - timer, "#00ff11", true) ..
               "image[" .. layout[1][1] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[1][2] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[1][3] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[2][1] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[2][2] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[2][3] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[3][1] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[3][2] .. ";1,1;" .. layout_bi .. "]" ..
               "image[" .. layout[3][3] .. ";1,1;" .. layout_bi .. "]" ..
               efs.list("context", "layout", layout_x, by, 3, 3) .. "tooltip[" ..
               layout_x .. "," .. by .. ";" .. layout_w .. "," .. layout_h ..
               ";" .. layout_tt .. ";" .. eletome.tooltip_color .. "]" ..
               efs.list("context", "src", 1, 4.25, 8, 2) .. "tooltip[1,4.25;" ..
               src_w .. "," .. src_h ..
               ";    Place stacks of items\n     here to keep planter\nsupplied with items to plant;" ..
               eletome.tooltip_color .. "]" .. epr.gui_player_inv(nil, 7) ..
               "listring[current_player;main]" .. "listring[context;src]" ..
               "listring[current_player;main]"
end

local function can_dig(pos, player)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    return inv:is_empty("src")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
    if minetest.is_protected(pos, player:get_player_name()) then return 0 end

    if listname == "layout" then
        local inv = minetest.get_meta(pos):get_inventory()
        stack:set_count(1)
        inv:set_stack(listname, index, stack)
        return 0
    end

    return stack:get_count()
end

local function allow_metadata_inventory_move(pos, from_list, from_index,
                                             to_list, to_index, count, player)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local stack = inv:get_stack(from_list, from_index)

    if from_list == "layout" then
        inv:set_stack(from_list, from_index, ItemStack(nil))
        return 0
    end

    return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
    if minetest.is_protected(pos, player:get_player_name()) then return 0 end

    if listname == "layout" then
        local inv = minetest.get_meta(pos):get_inventory()
        inv:set_stack(listname, index, ItemStack(nil))
        return 0
    end

    return stack:get_count()
end

local function plant(pos, range, stack, inv)

    local planted = 0
    local range_st = vector.add(ranges[range][1], pos)
    local range_end = vector.add(ranges[range][2], pos)

    local y_top = 0
    if minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name ~= "air" then
        y_top = y_top + 1
    end

    if not stack or stack:is_empty() then return 0 end

    local stackname = stack:get_name()

    local to_plant = nil
    local to_place = nil
    local amount = 0
    local till = true
    for _, test_stack in ipairs(inv:get_list("src")) do
        if test_stack:get_name() == stackname then
            amount = amount + test_stack:get_count()
        end
    end

    -- Saplings
    if ele.helpers.get_item_group(stackname, "sapling") then
        to_place = stackname
        to_plant = nil
        till = false
    elseif ele.helpers.get_item_group(stackname, "seed") or
        (mcl and stackname:match("seeds")) then
        to_plant = stackname
    end

    if (to_plant or to_place) and amount > 0 then
        for x = range_st.x, range_end.x do
            if amount == 0 then break end
            for z = range_st.z, range_end.z do
                if amount == 0 then break end
                local place_pos = {x = x, y = range_st.y + y_top, z = z}

                local base_pos = {
                    x = place_pos.x,
                    y = place_pos.y - 1,
                    z = place_pos.z
                }
                local base_node = minetest.get_node_or_nil(base_pos)

                -- Make sure we're planting on soil, till it if necessary
                if base_node and
                    ele.helpers.get_item_group(base_node.name, "soil") then
                    local node = minetest.get_node_or_nil(place_pos)
                    if node and node.name == "air" then
                        if till then
                            local regN = minetest.registered_nodes
                            if (regN[base_node.name].soil == nil or
                                regN[base_node.name].soil.wet == nil or
                                regN[base_node.name].soil.dry == nil) and
                                regN[epi.farming_soil] == nil then
                                till = false
                            end

                            if till then
                                minetest.sound_play(eps.dig_crumbly, {
                                    pos = base_pos,
                                    gain = 0.5
                                })

                                local soil = regN[base_node.name].soil
                                local wet_soil = epi.farming_soil_wet

                                -- Determine soil name
                                -- Make sure we don't replace wet soil
                                if soil then
                                    wet_soil = soil.wet or epi_farming_soil_wet
                                    soil = soil.dry
                                else
                                    soil = epi.farming_soil
                                end

                                if base_node.name ~= soil and base_node.name ~=
                                    wet_soil then
                                    minetest.set_node(base_pos, {name = soil})
                                end
                            end
                        end

                        local take = to_place
                        if to_place then
                            minetest.set_node(place_pos, {name = to_place})
                        else
                            local seeddef = minetest.registered_items[to_plant]

                            seeddef.on_place(ItemStack(to_plant), {
                                get_player_control = function()
                                    return {sneak = false}
                                end,
                                get_player_name = function()
                                    return ""
                                end
                            }, {
                                type = "node",
                                under = base_pos,
                                above = place_pos
                            })

                            take = to_plant
                        end

                        planted = planted + 1
                        amount = amount - 1

                        inv:remove_item("src", ItemStack(take, 1))
                    end
                end
            end
        end
    end

    return planted
end

local function on_timer(pos, elapsed)
    local refresh = false
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
    local usage = ele.helpers.get_node_property(meta, pos, "usage")
    local storage = ele.helpers.get_node_property(meta, pos, "storage")

    local work = meta:get_int("src_time")

    local state = meta:get_int("state")
    local is_enabled = ele.helpers.state_enabled(meta, pos, state)
    local pow_buffer = {capacity = capacity, storage = storage, usage = 0}
    local active = "Idle"

    if pow_buffer.storage > usage and is_enabled then
        if work == PLANTER_TICK then
            local planted = 0
            for index, slot in ipairs(inv:get_list("layout")) do

                if planted >= 9 then break end
                if not slot:is_empty() then
                    planted = planted + plant(pos, index, slot, inv)
                end
            end

            work = 0
            if planted > 0 then
                pow_buffer.storage = pow_buffer.storage - usage
            end
        else
            work = work + 1
        end

        active = "Active"
        refresh = true
        pow_buffer.usage = usage
    elseif not is_enabled then
        active = "Off"
    end

    local work_percent = math.floor((work / PLANTER_TICK) * 100)

    meta:set_string("formspec", get_formspec(work_percent, pow_buffer, state))
    meta:set_string("infotext", ("Planter %s\n%s"):format(active,
                                                          ele.capacity_text(
                                                              capacity, storage)))

    meta:set_int("storage", pow_buffer.storage)
    meta:set_int("src_time", work)

    return refresh
end

ele.register_base_device("elepower_farming:planter", {
    description = "Automatic Planter",
    ele_capacity = 12000,
    ele_inrush = 288,
    ele_usage = 128,
    tiles = {
        "elefarming_machine_planter.png", "elefarming_machine_base.png",
        "elefarming_machine_side.png", "elefarming_machine_side.png",
        "elefarming_machine_side.png", "elefarming_machine_side.png"
    },
    groups = {
        oddly_breakable_by_hand = 1,
        ele_machine = 1,
        ele_user = 1,
        cracky = 1,
        pickaxey = 1,
        tubedevice = 1,
        tubedevice_receiver = 1
    },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("layout", 9)
        inv:set_size("src", 16)

        meta:set_int("src_time", 0)

        local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
        meta:set_string("formspec",
                        get_formspec(0, {capacity = capacity, storage = 0}))
    end,
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_take = allow_metadata_inventory_take,
    allow_metadata_inventory_move = allow_metadata_inventory_move,
    can_dig = can_dig,
    on_timer = on_timer,
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2
})
