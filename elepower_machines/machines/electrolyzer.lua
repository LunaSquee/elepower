-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epi = ele.external.ing
local efs = ele.formspec
local S = ele.translator

elepm.electrolyzer_recipes = {
    {
        recipe = epi.water_source .. " 1000",
        output = {
            "elepower_dynamics:hydrogen 600", "elepower_dynamics:oxygen 400"
        },
        time = 20
    }, {
        recipe = "elepower_nuclear:heavy_water_source 1000",
        output = {
            "elepower_nuclear:deuterium 600", "elepower_dynamics:oxygen 400"
        },
        time = 20
    }, {
        recipe = "elepower_farming:biomass_source 1000",
        output = {
            "elepower_dynamics:nitrogen 400", "elepower_dynamics:oxygen 600"
        },
        time = 16
    }
}

local function get_formspec(time, power, input, out1, out2, state)
    local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)
    local move_two = 2.5

    return start .. efs.power_meter(power) ..

               efs.fluid_bar(bx + 1.25, by, input) ..
               efs.image(bx + 1.5, by + 2.9, 0.5, 0.5,
                         "elepower_gui_icon_fluid_electrolyzer_in.png") ..
               efs.tooltip(bx + 1.25, by + 2.5, 1, 1,
                           core.colorize("#0399c6",
                                         "     " .. S("Water") .. "\n" ..
                                             S("Heavy Water") .. "\n    " ..
                                             S("Biomass"))) ..

               efs.state_switcher(center_x, by, state) ..
               efs.progress(center_x, by + 1.25, time) ..

               efs.fluid_bar(mx - move_two, by, out1) ..
               efs.image(mx - move_two + 0.25, by + 2.9, 0.5, 0.5,
                         "elepower_gui_icon_fluid_electrolyzer_out1.png") ..
               efs.tooltip(mx - move_two, by + 2.5, 1, 1,
                           core.colorize("#0399c6",
                                         S("Hydrogen") .. "\n" .. S("Deuterium") ..
                                             "\n " .. S("Nitrogen"))) ..

               efs.fluid_bar(mx - 1.25, by, out2) ..
               efs.image(mx - 1, by + 2.9, 0.5, 0.5,
                         "elepower_gui_icon_fluid_electrolyzer_out2.png") ..
               efs.tooltip(mx - 1.25, by + 2.5, 1, 1,
                           core.colorize("#0399c6", S("Oxygen"))) ..

               epr.gui_player_inv() .. "listring[current_player;main]"
end

local function get_electrolysis_result(buffer)
    local result = {time = 0}
    if buffer.fluid == "" then return result end
    for _, recipe in pairs(elepm.electrolyzer_recipes) do
        local recipe_input = ItemStack(recipe.recipe)
        if buffer.fluid == recipe_input:get_name() and buffer.amount >=
            recipe_input:get_count() then
            result.recipe = recipe.recipe
            result.output = recipe.output
            result.time = recipe.time
            break
        end
    end
    return result
end

local function electrolyzer_timer(pos)
    local refresh = false

    local meta = minetest.get_meta(pos)

    local input = fluid_lib.get_buffer_data(pos, "input")
    local out1 = fluid_lib.get_buffer_data(pos, "out1")
    local out2 = fluid_lib.get_buffer_data(pos, "out2")

    local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
    local usage = ele.helpers.get_node_property(meta, pos, "usage")
    local storage = ele.helpers.get_node_property(meta, pos, "storage")
    local pow_buffer = {capacity = capacity, storage = storage, usage = 0}

    local time = meta:get_int("src_time")
    local state = meta:get_int("state")
    local status = S("Idle")

    local speed = 1

    local is_enabled = ele.helpers.state_enabled(meta, pos, state)
    local res_time = meta:get_int("src_time_max")

    while true do
        if not is_enabled then
            status = S("Off")
            time = 0
            break
        end

        local result = get_electrolysis_result(input)
        if result.time == 0 then break end

        if pow_buffer.storage < usage then
            status = S("Out of Power!")
            break
        end

        local out1s = ItemStack(result.output[1])
        local out2s = ItemStack(result.output[2])

        if fluid_lib.can_insert_into_buffer(pos, "out1", out1s:get_name(),
                                            out1s:get_count()) ~=
            out1s:get_count() or
            fluid_lib.can_insert_into_buffer(pos, "out2", out2s:get_name(),
                                             out2s:get_count()) ~=
            out2s:get_count() then
            status = S("Output Full!")
            break
        end

        status = S("Active")
        res_time = result.time
        pow_buffer.usage = usage
        pow_buffer.storage = pow_buffer.storage - usage
        time = time + ele.helpers.round(speed * 10)
        refresh = true

        if time <= ele.helpers.round(res_time * 10) then break end

        local istack = ItemStack(result.recipe)
        input.amount = input.amount - istack:get_count()
        if input.amount == 0 then input.fluid = "" end

        fluid_lib.insert_into_buffer(pos, "out1", out1s:get_name(),
                                     out1s:get_count())
        fluid_lib.insert_into_buffer(pos, "out2", out2s:get_name(),
                                     out2s:get_count())
        time = 0
        break
    end

    meta:set_int("input_fluid_storage", input.amount)
    meta:set_string("input_fluid", input.fluid)

    meta:set_int("src_time", time)
    meta:set_int("src_time_max", res_time)

    meta:set_int("storage", pow_buffer.storage)

    local time_percent = 0
    if res_time > 0 then
        time_percent = math.floor(100 * time / ele.helpers.round(res_time * 10))
    end

    meta:set_string("infotext",
                    (S("Electrolyzer") .. " %s\n%s"):format(status,
                                                   ele.capacity_text(
                                                       pow_buffer.capacity,
                                                       pow_buffer.storage)))
    meta:set_string("formspec", get_formspec(time_percent, pow_buffer, input,
                                             out1, out2, state))
    return refresh
end

ele.register_machine("elepower_machines:electrolyzer", {
    description = S("Electrolyzer"),
    tiles = {
        "elepower_machine_top.png", "elepower_machine_base.png",
        "elepower_machine_side.png", "elepower_machine_side.png",
        "elepower_machine_side.png",
        "elepower_machine_side.png^elepower_electrolyzer.png"
    },
    groups = {fluid_container = 1, cracky = 2, pickaxey = 2, ele_user = 1},
    on_timer = electrolyzer_timer,
    ele_usage = 128,
    ele_inrush = 128,
    fluid_buffers = {
        input = {
            accepts = {
                epi.water_source, "elepower_nuclear:heavy_water_source",
                "group:biomass", "group:electrolysis_recipe"
            },
            drainable = false,
            capacity = 8000
        },
        out1 = {
            accepts = {"group:gas", "group:electrolysis_result"},
            drainable = true,
            capacity = 8000
        },
        out2 = {
            accepts = {"group:gas", "group:electrolysis_result"},
            drainable = true,
            capacity = 8000
        }
    },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", get_formspec())
    end
})
