-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local myname = "elepower_nuclear:fission_controller"

local function check(pos)
    local reactpos = vector.add(pos, {x = 0, y = -1, z = 0})
    local reactnode = minetest.get_node_or_nil(reactpos)

    local coolpos = vector.add(pos, {x = 0, y = -2, z = 0})
    local coolnode = minetest.get_node_or_nil(coolpos)

    if not reactnode or reactnode.name ~= "elepower_nuclear:fission_core" then
        return nil
    end

    if not coolnode or coolnode.name ~= "elepower_nuclear:reactor_fluid_port" then
        return nil
    end

    return {
        control_meta = minetest.get_meta(pos),
        core = reactpos,
        core_meta = minetest.get_meta(reactpos),
        coolant = coolpos,
        coolant_meta = minetest.get_meta(coolpos)
    }
end

local function get_controller_formspec(meta, y, x_min, x_max, btn_min, btn_max,
                                       btn_center)
    local ctrls = {}
    local rods = 4
    local gutter = 0.25
    local stops = ((x_max - x_min) + gutter) / (rods - 1) - gutter - 0.125
    local selected = meta:get_int("selected")

    for i = 1, rods do
        local setting = meta:get_int("c" .. i)
        local xoffset = x_min + (stops * (i - 1)) + gutter
        local sel = ""

        if i == selected then sel = " <- " end

        local fspc = efs.label(xoffset, y, setting .. " %" .. sel)
        fspc = fspc ..
                   efs.create_bar(xoffset, y + 0.25, 100 - setting, "#252625",
                                  true)

        table.insert(ctrls, fspc)
    end

    return table.concat(ctrls, "") ..
               efs.button(btn_min, y + 3.5, 1.5, 0.5, "next", S("Next")) ..
               efs.button(btn_min + 1.75, y + 3.5, 1.5, 0.5, "prev",
                          S("Previous")) ..
               efs.button(btn_center - 0.25, y + 3.5, 1.5, 0.5, "stop",
                          S("SCRAM")) ..
               efs.button(btn_max - 1.5, y + 3.5, 1.5, 0.5, "up", S("Raise")) ..
               efs.button(btn_max - 3.25, y + 3.5, 1.5, 0.5, "down", S("Lower")) ..
               "tooltip[next;" .. S("Select the next control rod") .. "]" ..
               "tooltip[prev;" .. S("Select the previous control rod") .. "]" ..
               "tooltip[stop;" ..
               S(
                   "Drops all the rods into the reactor core, instantly stopping it") ..
               "]" .. "tooltip[up;" .. S("Raise selected control rod") .. "]" ..
               "tooltip[down;" .. S("Lower selected control rod") .. "]"
end

local function get_formspec(pos, power, station, station_meta)
    local metas = check(pos)
    local width = metas and 12.75 or 11.75
    local start, bx, by, mx, _, center_x = efs.begin(width, 10.45)
    local fspec = efs.list("context", "card", center_x, by, 1, 1)

    -- local comps = station_meta:get_string("components")
    -- local seeitems = comps:match("elepower_wireless:upgrade_item_transfer") ~= nil

    if metas then
        fspec = efs.list("context", "card", bx + 2.25, by, 1, 1)
        width = 12.75

        -- Reactor Core

        local power = metas.core_meta:get_int("setting")
        local heat = metas.core_meta:get_int("heat")

        local status = S("Activate by extracting the control rods")

        if heat > 80 then
            status = S("!!! TEMPERATURE CRITICAL !!!")
        elseif heat > 90 then
            status = S("!!! REACTOR CRITICAL !!!")
        elseif heat > 95 then
            status = S("!!! REACTOR MELTDOWN IMMINENT !!!")
        elseif power > 0 then
            status = S("Active reaction chain")
        end

        fspec =
            fspec .. efs.create_bar(bx + 1.25, by, power, "#ff0000", true) ..
                efs.create_bar(bx + 1.75, by, heat, "#ffdd11", true) ..
                efs.tooltip(bx + 1.25, by, 0.25, 2.9,
                            S("Power: @1", power .. "%")) ..
                efs.tooltip(bx + 1.75, by, 0.25, 2.9, S("Heat: @1", heat .. "%")) ..
                efs.label(bx + 1.25, by + 4.25, status)

        -- Rods
        fspec = fspec ..
                    get_controller_formspec(metas.control_meta, by, bx + 3.5,
                                            mx - 3, bx + 1.25, mx - 1.25,
                                            center_x)

        -- Coolant port

        local cool = fluid_lib.get_buffer_data(metas.coolant, "cool")
        local hot = fluid_lib.get_buffer_data(metas.coolant, "hot")

        fspec = fspec .. efs.fluid_bar(mx - 1, by, hot) ..
                    efs.fluid_bar(mx - 2.25, by, cool)

        -- if seeitems then
        --	fspec = fspec ..
        --		"button[2,1;1,1;inv;Items]"
        -- end
    end

    return
        start .. efs.power_meter(power) .. epr.gui_player_inv(width) .. fspec ..
            "listring[current_player;main]" .. "listring[context;card]" ..
            "listring[current_player;main]"
end

local function on_receive_fields(pos, fields, sender, station, station_meta)
    -- if fields["inv"] then
    --	return
    -- end

    return minetest.registered_nodes[myname].on_receive_fields(pos, myname,
                                                               fields, sender)
end

elewi.register_handler(myname, {
    get_formspec = get_formspec,
    on_receive_fields = on_receive_fields
})
