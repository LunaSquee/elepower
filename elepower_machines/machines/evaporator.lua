-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local function get_formspec(power, input, output, state)
    local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)

    return start .. efs.power_meter(power) ..
               efs.state_switcher(center_x, by, state) ..
               efs.fluid_bar(bx + 1.25, by, input) ..
               efs.fluid_bar(mx - 1, by, output) ..
               efs.progress(center_x, by + 1.25, 0) .. epr.gui_player_inv() ..
               "listring[current_player;main]"
end

local function on_timer(pos, elapsed)
    local refresh = false
    local meta = minetest.get_meta(pos)

    local input = fluid_lib.get_buffer_data(pos, "input")
    local output = fluid_lib.get_buffer_data(pos, "output")
    local state = meta:get_int("state")

    local is_enabled = ele.helpers.state_enabled(meta, pos, state)

    local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
    local usage = ele.helpers.get_node_property(meta, pos, "usage")
    local storage = ele.helpers.get_node_property(meta, pos, "storage")
    local pow_buffer = {capacity = capacity, storage = storage, usage = 0}

    local efficiency = 0.8
    local status = S("Idle")

    while true do
        if not is_enabled then
            status = S("Off")
            break
        end

        if pow_buffer.storage < usage then
            status = S("Out of Power!")
            break
        end

        if input.fluid == "" or input.amount == 0 then break end

        local fdef = minetest.registered_nodes[input.fluid]
        if not fdef["gas_form"] then break end

        local inp = input.amount
        if inp > 100 then inp = 100 end
        local outp = math.floor(inp * efficiency)

        if (output.amount + outp > output.capacity) or
            (output.fluid ~= "" and output.fluid ~= fdef["gas_form"]) then
            break
        end

        status = S("Active")
        pow_buffer.usage = usage
        pow_buffer.storage = pow_buffer.storage - usage
        output.amount = output.amount + outp
        output.fluid = fdef["gas_form"]
        input.amount = input.amount - inp
        refresh = true

        if input.amount == 0 then input.fluid = "" end

        break
    end

    if refresh then
        ele.helpers.swap_node(pos, "elepower_machines:evaporator_active")
    else
        ele.helpers.swap_node(pos, "elepower_machines:evaporator")
    end

    meta:set_int("input_fluid_storage", input.amount)
    meta:set_string("input_fluid", input.fluid)

    meta:set_int("output_fluid_storage", output.amount)
    meta:set_string("output_fluid", output.fluid)

    meta:set_int("storage", pow_buffer.storage)

    meta:set_string("infotext",
                    (S("Evaporator") .. " %s\n%s"):format(status,
                                                          ele.capacity_text(
                                                              pow_buffer.capacity,
                                                              pow_buffer.storage)))
    meta:set_string("formspec", get_formspec(pow_buffer, input, output, state))

    return refresh
end

local animated = {
    name = "elepower_machine_base.png^elepower_machine_vaporidenser_animated.png",
    animation = {
        type = "vertical_frames",
        aspect_w = 16,
        aspect_h = 16,
        length = 2.0
    }
}

ele.register_machine("elepower_machines:evaporator", {
    description = S("Evaporator"),
    groups = {
        oddly_breakable_by_hand = 1,
        cracky = 3,
        pickaxey = 1,
        fluid_container = 1,
        ele_user = 1
    },
    fluid_buffers = {
        input = {capacity = 8000, accepts = {"group:liquid"}, drainable = false},
        output = {capacity = 8000, accepts = false, drainable = true}
    },
    on_timer = on_timer,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", get_formspec())
    end,
    tiles = {
        "elepower_machine_top.png^elepower_power_port.png",
        "elepower_machine_base.png^elepower_power_port.png",
        "elepower_machine_side.png^elepower_machine_vaporidenser.png"
    },
    ele_active_node = true,
    ele_no_automatic_ports = true,
    ele_active_nodedef = {
        tiles = {
            "elepower_machine_top.png^elepower_power_port.png",
            "elepower_machine_base.png^elepower_power_port.png", animated
        }
    },
    ele_usage = 128
})
