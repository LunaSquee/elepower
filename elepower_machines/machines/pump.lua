-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epi = ele.external.ing
local efs = ele.formspec
local S = ele.translator

local c_air = minetest.get_content_id("air")

local function get_formspec(power, fluid, state, level)
    local start, bx, by, mx = efs.begin(11.75, 10.45)
    if not level then level = 0 end
    return start .. efs.state_switcher(mx - 1, by + 3, state) ..
               efs.power_meter(power) .. efs.fluid_bar(mx - 1, by, fluid) ..
               efs.label(bx + 1.25, by + 0.125, "Pump level: " .. level) ..
               epr.gui_player_inv()
end

-- Dig a node in a certain radius on the same Y level
local function dig_node_leveled_radius(pos, radius, node)
    local c_node = minetest.get_content_id(node)
    local startp = vector.subtract(pos, {x = radius, y = 0, z = radius})
    local endp = vector.add(pos, {x = radius, y = 0, z = radius})

    local manip = minetest.get_voxel_manip()
    local e1, e2 = manip:read_from_map(startp, endp)
    local area = VoxelArea:new{MinEdge = e1, MaxEdge = e2}
    local data = manip:get_data()

    local dug = false

    for i in area:iter(startp.x, startp.y, startp.z, endp.x, endp.y, endp.z) do
        if data[i] == c_node then
            data[i] = c_air
            dug = true
            break
        end
    end

    if dug then
        manip:set_data(data)
        manip:write_to_map()
    end

    return dug
end

local function timer(pos, elapsed)
    local refresh = false
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local machine_node = "elepower_machines:pump"
    local machine_def = minetest.registered_nodes[machine_node]

    local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
    local usage = ele.helpers.get_node_property(meta, pos, "usage")
    local storage = ele.helpers.get_node_property(meta, pos, "storage")
    local state = meta:get_int("state")
    local comps = meta:get_string("components")
    local status = "Idle"

    local is_enabled = ele.helpers.state_enabled(meta, pos, state)
    local res_time = 0

    local pow_buffer = {capacity = capacity, storage = storage, usage = 0}
    local fl_buffer = fluid_lib.get_buffer_data(pos, "pump")

    -- Pump level
    local plevel = meta:get_int("level")
    local pliquid = meta:get_string("liquid")
    if plevel == 0 then plevel = -1 end

    local ppos = vector.add(pos, {x = 0, y = plevel, z = 0})

    local heavy = comps:match("elepower_machines:heavy_filter") ~= nil
    local spawn_pipes = false

    while true do
        if not is_enabled then
            status = S("Off")
            break
        end

        if pow_buffer.storage < usage then
            status = S("Out of Power!")
            break
        end

        local dig_node = pliquid
        local amount = 1000
        if pliquid == "elepower_nuclear:heavy_water_source" and heavy then
            dig_node = epi.water_source
            amount = 200
        end

        if fl_buffer.amount + amount > fl_buffer.capacity then
            status = S("Tank Full!")
            break
        end

        if pliquid == "" then
            local liquid_list = fluid_lib.get_liquid_list()
            local node = minetest.get_node_or_nil(ppos)
            if not node or node.name == "air" or
                (liquid_list[node.name] and
                    fluid_lib.get_flowing_for_source(node.name) == node.name) then
                plevel = plevel - 1
                status = S("Seeking")
                spawn_pipes = true
                refresh = true
                if plevel < -16 then plevel = -1 end
                break
            end

            -- Valid liquid, proceed pumping
            if liquid_list[node.name] ~= nil then
                if node.name == epi.water_source and heavy then
                    node.name = "elepower_nuclear:heavy_water_source"
                end

                pliquid = node.name
                refresh = true
            else
                -- Run into a non-liquid node, stop the timer
                refresh = false
            end
            break
        end

        if pliquid ~= "" then
            -- Filter was installed
            if pliquid == epi.water_source and heavy and fl_buffer.amount > 0 then
                pliquid = "elepower_nuclear:heavy_water_source"
                fl_buffer.amount = 0
                refresh = true
                break
            end

            -- We are looking for `fl_buffer.fluid` on Y level `plevel`
            -- If we find a fluid node, we dig it, and add it to the buffer's storage
            -- If we don't find a fluid node, we go a level down
            local dug = dig_node_leveled_radius(ppos, 16, dig_node)
            if not dug then
                local node = minetest.get_node_or_nil(ppos)
                if node.name == epi.water_source and heavy then
                    node.name = "elepower_nuclear:heavy_water_source"
                end

                if not node or (node.name ~= pliquid and node.name ~= "air") then
                    status = S("No More Fluid!")
                    refresh = false
                    break
                end

                plevel = plevel - 1
                refresh = true
                if plevel < -16 then plevel = -1 end
                break
            else
                fl_buffer.amount = fl_buffer.amount + amount
                pow_buffer.usage = usage
                pow_buffer.storage = pow_buffer.storage - usage
                status = S("Pumping")
                spawn_pipes = true
                refresh = true
            end
        end

        break
    end

    fl_buffer.fluid = pliquid

    -- Spawn tube entities
    if spawn_pipes then
        for i = 1, math.abs(plevel) do
            local tentpos = vector.subtract(pos, {x = 0, y = i, z = 0})
            local skip = false
            for i, ob in pairs(minetest.get_objects_inside_radius(tentpos, 0.5)) do
                if ob:get_luaentity() and ob:get_luaentity().name ==
                    "elepower_machines:pump_tube" then
                    skip = true
                    break
                end
            end

            if not skip then
                local e = minetest.add_entity(tentpos,
                                              "elepower_machines:pump_tube")

                local ent = e:get_luaentity()
                ent.pump = pos
                ent.level = i * -1
            end
        end
    end

    meta:set_string("formspec",
                    get_formspec(pow_buffer, fl_buffer, state, plevel))
    meta:set_string("infotext",
                    ("%s %s"):format(machine_def.description, status) .. "\n" ..
                        ele.capacity_text(capacity, storage))

    meta:set_int("storage", pow_buffer.storage)
    meta:set_int("level", plevel)
    meta:set_string("liquid", pliquid)

    meta:set_int("pump_fluid_storage", fl_buffer.amount)
    meta:set_string("pump_fluid", fl_buffer.fluid)

    return refresh
end

ele.register_machine("elepower_machines:pump", {
    description = S("Pickup Pump Tank"),
    tiles = {
        "elepower_machine_top.png^elepower_power_port.png",
        "elepower_machine_base.png^elepower_pump_base.png",
        "elepower_machine_side.png^elepower_pump_side.png",
        "elepower_machine_side.png^elepower_pump_side.png",
        "elepower_machine_side.png^elepower_pump_side.png",
        "elepower_machine_side.png^elepower_pump_side.png"
    },
    groups = {
        ele_machine = 1,
        ele_user = 1,
        fluid_container = 1,
        oddly_breakable_by_hand = 1
    },
    ele_no_automatic_ports = true,
    fluid_buffers = {pump = {capacity = 16000, drainable = true}},
    on_timer = timer,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", get_formspec(nil, nil, 0, -1))
    end,
    -- Upgradable
    ele_upgrades = {pump_filter = {}, capacitor = {"capacity"}}
})

minetest.register_entity("elepower_machines:pump_tube", {
    initial_properties = {
        hp_max = 1,
        visual = "mesh",
        mesh = "elepower_pump_tube.obj",
        physical = false,
        textures = {"elepower_pump_tube.png"}

    },
    timer = 0,
    pump = {x = 0, y = 0, z = 0},
    level = 0,
    on_step = function(self, dt)
        self.timer = self.timer + 1
        if self.timer < 50 then return self end
        self.timer = 0

        -- Check for pump
        local pump = minetest.get_node_or_nil(self.pump)
        if not pump or pump.name ~= "elepower_machines:pump" then
            -- Delete self if pump wasn't found
            self.object:remove()
            return self
        else
            -- Delete self if pump's discovery level is above tube's level
            local meta = minetest.get_meta(self.pump)
            local pl = meta:get_int("level")
            if pl > self.level then
                self.object:remove()
                return self
            end
        end
    end
})
