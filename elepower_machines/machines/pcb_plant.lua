-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local function get_formspec(power, input, state, active, percent)
    local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)

    local t = active and "elepower_uv_bulb_lit.png" or "elepower_uv_bulb.png"
    if not percent then percent = 0 end

    return start .. efs.power_meter(power) ..
               efs.state_switcher(mx - 1, by, state) ..
               efs.fluid_bar(bx + 1.25, by, input) ..
               efs.progress(center_x, by + 1.25, percent) ..
               efs.image(center_x, by + 2.5, 1, 1, t) ..
               efs.list("context", "src", center_x - 1.25, by + 1.25, 1, 1) ..
               efs.list("context", "dst", center_x + 1.25, by + 1.25, 1, 1) ..
               epr.gui_player_inv() .. "listring[current_player;main]" ..
               "listring[context;src]" .. "listring[current_player;main]" ..
               "listring[context;dst]" .. "listring[current_player;main]"
end

local function on_timer(pos, elapsed)
    local refresh = false
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local input = fluid_lib.get_buffer_data(pos, "acid")
    local src = inv:get_stack("src", 1)
    local dst = inv:get_stack("dst", 1)
    local state = meta:get_int("state")
    local time = meta:get_int("time")

    local is_enabled = ele.helpers.state_enabled(meta, pos, state)

    local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
    local usage = ele.helpers.get_node_property(meta, pos, "usage")
    local storage = ele.helpers.get_node_property(meta, pos, "storage")
    local pow_buffer = {capacity = capacity, storage = storage, usage = 0}

    local status = S("Idle")
    local active = false

    while true do
        if not is_enabled then
            status = S("Off")
            break
        end

        if pow_buffer.storage < usage then
            status = S("Out of Power!")
            break
        end

        if src:is_empty() or src:get_name() ~= "elepower_dynamics:pcb_blank" then
            time = 0
            break
        end

        if input.fluid == "" or input.amount < 10 then
            status = S("Out of Acid!")
            time = 0
            break
        end

        status = S("Active")
        active = true
        pow_buffer.usage = usage
        pow_buffer.storage = pow_buffer.storage - usage

        input.amount = input.amount - 10
        refresh = true

        if input.amount == 0 then input.fluid = "" end

        if time < 4 then
            time = time + 1
            break
        end

        if not inv:room_for_item("dst", ItemStack("elepower_dynamics:pcb")) then
            status = S("Output Full!")
            break
        end

        src:take_item(1)
        inv:add_item("dst", "elepower_dynamics:pcb")
        inv:set_list("src", {src})
        time = 0

        break
    end

    if active then
        ele.helpers.swap_node(pos, "elepower_machines:pcb_plant_active")
    else
        ele.helpers.swap_node(pos, "elepower_machines:pcb_plant")
    end

    meta:set_int("acid_fluid_storage", input.amount)
    meta:set_string("acid_fluid", input.fluid)

    meta:set_int("storage", pow_buffer.storage)
    meta:set_int("time", time)

    meta:set_string("infotext",
                    (S("Printed Circuit Board Plant") .. " %s\n%s"):format(
                        status, ele.capacity_text(pow_buffer.capacity,
                                                  pow_buffer.storage)))
    meta:set_string("formspec", get_formspec(pow_buffer, input, state, active,
                                             math.floor((time / 4) * 100)))

    return refresh
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
    if minetest.is_protected(pos, player:get_player_name()) then return 0 end

    if listname == "dst" or
        (listname == "src" and stack:get_name() ~= "elepower_dynamics:pcb_blank") then
        return 0
    end

    return stack:get_count()
end

local function allow_metadata_inventory_move(pos, from_list, from_index,
                                             to_list, to_index, count, player)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local stack = inv:get_stack(from_list, from_index)
    return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

ele.register_machine("elepower_machines:pcb_plant", {
    description = S("Printed Circuit Board Plant"),
    groups = {
        fluid_container = 1,
        cracky = 3,
        pickaxey = 1,
        ele_user = 1,
        tubedevice = 1,
        tubedevice_receiver = 1,
        oddly_breakable_by_hand = 1
    },
    fluid_buffers = {
        acid = {
            capacity = 8000,
            accepts = {"elepower_dynamics:etching_acid_source"},
            drainable = false
        }
    },
    on_timer = on_timer,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("src", 1)
        inv:set_size("dst", 1)
        meta:set_string("formspec", get_formspec())
    end,
    tiles = {
        "elepower_machine_top.png", "elepower_machine_base.png",
        "elepower_machine_side.png", "elepower_machine_side.png",
        "elepower_machine_side.png",
        "elepower_machine_side.png^elepower_pcb_plant.png"
    },
    ele_active_node = true,
    ele_active_nodedef = {
        tiles = {
            "elepower_machine_top.png", "elepower_machine_base.png",
            "elepower_machine_side.png", "elepower_machine_side.png",
            "elepower_machine_side.png",
            "elepower_machine_side.png^elepower_pcb_plant_active.png"
        }
    },
    ele_usage = 32,
    allow_metadata_inventory_put = allow_metadata_inventory_put,
    allow_metadata_inventory_move = allow_metadata_inventory_move
})
