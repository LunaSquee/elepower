-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epg = ele.external.graphic
local efs = ele.formspec
local S = ele.translator

local function get_formspec_default(power, state)
    local start, _, by, mx = efs.begin(11.75, 10.45)
    return start .. efs.power_meter(power) ..
               efs.state_switcher(mx - 1, by, state) .. epr.gui_player_inv()
end

-- Primitive wind checking function
elepm.wind_height_constant = 20
function elepm.wind_check(pos)
    if pos.y < 10 then return 0 end

    local power = math.ceil(pos.y / elepm.wind_height_constant)

    if math.floor(pos.y / elepm.wind_height_constant) > 25 then power = 25 end

    return power
end

-- A generator that creates power using altitude
function ele.register_wind_generator(nodename, nodedef)
    -- Allow for custom formspec
    local get_formspec = get_formspec_default
    if nodedef.get_formspec then
        get_formspec = nodedef.get_formspec
        nodedef.get_formspec = nil
    end

    local defaults = {
        groups = {
            ele_provider = 1,
            oddly_breakable_by_hand = 1,
            wind_generator = 1
        },
        tube = false,
        paramtype2 = 0,
        on_timer = function(pos, elapsed)

            local refresh = false
            local meta = minetest.get_meta(pos)

            local capacity = ele.helpers
                                 .get_node_property(meta, pos, "capacity")
            local generation = ele.helpers.get_node_property(meta, pos, "usage")
            local storage = ele.helpers.get_node_property(meta, pos, "storage")

            local state = meta:get_int("state")
            local is_enabled = ele.helpers.state_enabled(meta, pos, state)

            local pow_buffer = {
                capacity = capacity,
                storage = storage,
                usage = 0
            }
            local status = S("Idle")

            local wind = meta:get_int("wind")

            while true do
                if not is_enabled then
                    status = S("Off")
                    wind = 0
                    break
                end

                local multiplier = 1
                local tentpos = vector.subtract(pos, {x = 0, y = 0, z = 1})
                for i, ob in pairs(minetest.get_objects_inside_radius(tentpos,
                                                                      0.5)) do
                    if ob:get_luaentity() and ob:get_luaentity().name ==
                        "elepower_machines:wind_turbine_blades" then
                        multiplier = 4
                        break
                    end
                end

                wind = elepm.wind_check(pos) * multiplier

                if wind == 0 then
                    status = S("No wind")
                    break
                end

                pow_buffer.usage = wind
                if pow_buffer.storage + pow_buffer.usage > pow_buffer.capacity then
                    break
                end

                status = S("Active")
                refresh = true

                pow_buffer.storage = pow_buffer.storage + pow_buffer.usage
                break
            end

            meta:set_string("formspec", get_formspec(pow_buffer, state))
            meta:set_string("infotext",
                            (S("Wind Turbine") .. " %s\n%s"):format(status,
                                                                    ele.capacity_text(
                                                                        capacity,
                                                                        pow_buffer.storage)))

            meta:set_int("storage", pow_buffer.storage)
            meta:set_int("wind", wind)

            return refresh
        end,
        on_construct = function(pos)
            local meta = minetest.get_meta(pos)

            local capacity = ele.helpers
                                 .get_node_property(meta, pos, "capacity")
            local storage = ele.helpers.get_node_property(meta, pos, "storage")

            meta:set_string("formspec", get_formspec(
                                {
                    capacity = capacity,
                    storage = storage,
                    usage = 0
                }, 0))
            minetest.get_node_timer(pos):start(1)
        end
    }

    for key, val in pairs(defaults) do
        if not nodedef[key] then nodedef[key] = val end
    end

    ele.register_machine(nodename, nodedef)
end

ele.register_wind_generator("elepower_machines:wind_turbine", {
    description = S("Wind Turbine") .. "\n" .. "(" ..
        S("Requires Wind Turbine Blades") .. ")",
    tiles = {
        "elepower_machine_top.png", "elepower_machine_base.png",
        "elepower_machine_side.png", "elepower_machine_side.png",
        "elepower_machine_side.png",
        "elepower_machine_side.png^elepower_wind_turbine_face.png"
    },
    ele_upgrades = {capacitor = {"capacity"}}
})

minetest.register_craftitem("elepower_machines:wind_turbine_blades", {
    description = S("Wind Turbine Blades (Wooden)") .. "\n" ..
        S("Sneak Right-Click on the Wind Turbine node to place it"),
    inventory_image = "elepower_wind_turbine_blades.png",
    on_place = function(itemstack, clicker, pointed_thing)
        local pos = pointed_thing.under
        if pointed_thing.type ~= "node" then return itemstack end

        local node = minetest.get_node(pos)
        if minetest.get_item_group(node.name, "wind_generator") == 0 then
            return itemstack
        end
        local place_at = vector.add(pos, {x = 0, y = 0, z = -1})
        local e = minetest.add_entity(place_at,
                                      "elepower_machines:wind_turbine_blades")
        local ent = e:get_luaentity()
        ent.controller = pos

        itemstack:take_item(1)
        return itemstack
    end
})

minetest.register_entity("elepower_machines:wind_turbine_blades", {
    initial_properties = {
        hp_max = 10,
        visual = "mesh",
        mesh = "elepower_wind_blades.obj",
        physical = true,
        textures = {epg.wood},
        backface_culling = false,
        visual_size = {x = 10, y = 10}
    },
    timer = 0,
    wind = false,

    on_step = function(self, dt)
        if self.wind then
            local rot = self.object:get_rotation()
            self.object:set_rotation({x = 0, y = 0, z = rot.z + 0.02 * math.pi})
        end

        -- Wind check timer
        self.timer = self.timer + 1

        if self.timer < 100 then return self end
        self.timer = 0

        -- controller pos always +1 z (note this can be made more robust)
        local controller = vector.add(self.object:get_pos(),
                                      {x = 0, y = 0, z = 1})
        local c_meta = minetest.get_meta(controller)

        -- check controller timer (already using onstep here so saves an extra one)
        if not minetest.get_node_timer(controller):is_started() then
            minetest.get_node_timer(controller):start(1)
        end

        if c_meta and c_meta:get_int("wind") > 0 then
            self.wind = true
        else
            self.wind = false
        end

    end,
    on_punch = function(self, puncher, time_from_last_punch, tool_capabilities,
                        dir)
        local itm = ItemStack("elepower_machines:wind_turbine_blades")
        if not puncher or puncher == "" or puncher:get_player_name() == "" then
            return self
        end
        local inv = puncher:get_inventory()
        if inv:room_for_item("main", itm) then
            inv:add_item("main", itm)
        else
            minetest.item_drop(itm, puncher, self.object:get_pos())
        end
        self.object:set_hp(0)
    end
})
