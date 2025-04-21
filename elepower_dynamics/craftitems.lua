-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epi = ele.external.ing
local S = ele.translator

----------------
-- Craftitems --
----------------

-- Ingots

minetest.register_craftitem("elepower_dynamics:lead_ingot", {
    description = S("Lead Ingot"),
    inventory_image = "elepower_lead_ingot.png",
    groups = {lead = 1, ingot = 1}
})

if epi.iron_ingot == "" then
    minetest.register_craftitem("elepower_dynamics:iron_ingot", {
        description = S("Iron Ingot"),
        inventory_image = "elepower_iron_ingot.png",
        groups = {iron = 1, ingot = 1}
    })
else
    minetest.register_alias("elepower_dynamics:iron_ingot", epi.iron_ingot)
end

if epi.steel_ingot ~= "" then
    minetest.override_item(epi.steel_ingot,
                           {description = S("Low Carbon Steel Ingot")})
    minetest.register_alias("elepower_dynamics:steel_ingot", epi.steel_ingot)
else
    minetest.register_craftitem("elepower_dynamics:steel_ingot", {
        description = S("Low Carbon Steel Ingot"),
        inventory_image = "elepower_steel_ingot.png",
        groups = {steel = 1, ingot = 1}
    })
end

minetest.register_craftitem("elepower_dynamics:nickel_ingot", {
    description = S("Nickel Ingot"),
    inventory_image = "elepower_nickel_ingot.png",
    groups = {nickel = 1, ingot = 1}
})

minetest.register_craftitem("elepower_dynamics:invar_ingot", {
    description = S("Invar Ingot"),
    inventory_image = "elepower_invar_ingot.png",
    groups = {invar = 1, ingot = 1}
})

minetest.register_craftitem("elepower_dynamics:electrum_ingot", {
    description = S("Electrum Ingot"),
    inventory_image = "elepower_electrum_ingot.png",
    groups = {electrum = 1, ingot = 1}
})

minetest.register_craftitem("elepower_dynamics:viridisium_ingot", {
    description = S("Viridisium Ingot"),
    inventory_image = "elepower_viridisium_ingot.png",
    groups = {viridisium = 1, ingot = 1}
})

minetest.register_craftitem("elepower_dynamics:zinc_ingot", {
    description = S("Zinc Ingot"),
    inventory_image = "elepower_zinc_ingot.png",
    groups = {zinc = 1, ingot = 1}
})

minetest.register_craftitem("elepower_dynamics:graphite_ingot", {
    description = S("Graphite Ingot"),
    inventory_image = "elepower_graphite_ingot.png",
    groups = {graphite = 1, ingot = 1}
})

-- Lumps

minetest.register_craftitem("elepower_dynamics:lead_lump", {
    description = S("Lead Lump"),
    inventory_image = "elepower_lead_lump.png",
    groups = {lead = 1, lump = 1}
})

minetest.register_craftitem("elepower_dynamics:nickel_lump", {
    description = S("Nickel Lump"),
    inventory_image = "elepower_nickel_lump.png",
    groups = {nickel = 1, lump = 1}
})

minetest.register_craftitem("elepower_dynamics:viridisium_lump", {
    description = S("Viridisium Lump"),
    inventory_image = "elepower_viridisium_lump.png",
    groups = {viridisium = 1, lump = 1}
})

minetest.register_craftitem("elepower_dynamics:zinc_lump", {
    description = S("Zinc Lump"),
    inventory_image = "elepower_zinc_lump.png",
    groups = {zinc = 1, lump = 1}
})

minetest.register_craftitem("elepower_dynamics:xycrone_lump", {
    description = S("Xycrone") .. S("Used for Quantum Entanglement") .. "\n\n" ..
        S("Unstable"),
    inventory_image = "elepower_xycrone.png",
    groups = {xycrone = 1, lump = 1}
})

-- Special

minetest.register_craftitem("elepower_dynamics:graphite_rod", {
    description = S("Graphite Rod"),
    inventory_image = "elepower_graphite_rod.png",
    groups = {graphite = 1, rod = 1}
})

minetest.register_craftitem("elepower_dynamics:carbon_fiber", {
    description = S("Carbon Fibers"),
    inventory_image = "elepower_carbon_fiber.png",
    groups = {carbon_fiber = 1}
})

minetest.register_craftitem("elepower_dynamics:carbon_sheet", {
    description = S("Carbon Fiber Sheet"),
    inventory_image = "elepower_carbon_fiber_sheet.png",
    groups = {carbon_fiber_sheet = 1, sheet = 1}
})

minetest.register_craftitem("elepower_dynamics:silicon_wafer", {
    description = S("Silicon Wafer"),
    inventory_image = "elepower_silicon_wafer.png",
    groups = {wafer = 1}
})

minetest.register_craftitem("elepower_dynamics:silicon_wafer_doped", {
    description = S("Doped Silicon Wafer"),
    inventory_image = "elepower_silicon_wafer_solar.png",
    groups = {wafer = 2}
})

minetest.register_craftitem("elepower_dynamics:tree_tap", {
    description = S("Steel Treetap"),
    inventory_image = "elepower_tree_tap.png",
    groups = {treetap = 1, static_component = 1}
})

minetest.register_craftitem("elepower_dynamics:tin_can", {
    description = S("Tin Can"),
    inventory_image = "elepower_tin_can.png",
    groups = {can = 1, food_grade = 1}
})

minetest.register_craftitem("elepower_dynamics:pcb_blank", {
    description = S("Printed Circuit Board (PCB) Blank") .. "\n" ..
        S("Use Etching Acid to etch"),
    inventory_image = "elepower_blank_pcb.png",
    liquids_pointable = true,
    groups = {blank_board = 1, static_component = 1},
    on_place = function(itemstack, placer, pointed_thing)
        local pos = pointed_thing.under
        if not pos or pointed_thing.type ~= "node" then return itemstack end

        local node = minetest.get_node_or_nil(pos)
        if not node or node.name ~= "elepower_dynamics:etching_acid_source" then
            return itemstack
        end

        if not placer or placer:get_player_name() == "" then
            return itemstack
        end

        local out = ItemStack("elepower_dynamics:pcb")
        local inv = placer:get_inventory()
        local meta = minetest.get_meta(pos)
        local uses = meta:get_int("uses")

        uses = uses + 1
        itemstack:take_item(1)

        if inv:room_for_item("main", out) then
            inv:add_item("main", out)
        else
            minetest.item_drop(out, placer, pos)
        end

        -- Limited etchings
        if uses == 10 then
            minetest.set_node(pos, {name = epi.water_source})
        else
            meta:set_int("uses", uses)
        end

        return itemstack
    end
})

minetest.register_craftitem("elepower_dynamics:pcb", {
    description = S("Printed Circuit Board (PCB)"),
    inventory_image = "elepower_pcb.png",
    groups = {pcb = 1, static_component = 1}
})

minetest.register_craftitem("elepower_dynamics:acidic_compound", {
    description = S("Acidic Compound") .. "\n" ..
        S("Right-Click on Water to turn it into Etching Acid"),
    inventory_image = "elepower_acidic_compound.png",
    liquids_pointable = true,
    groups = {acid = 1, static_component = 1},
    on_place = function(itemstack, placer, pointed_thing)
        local pos = pointed_thing.under
        local node = minetest.get_node(pos)

        if node.name ~= epi.water_source then return itemstack end

        minetest.set_node(pos, {name = "elepower_dynamics:etching_acid_source"})
        itemstack:take_item(1)

        return itemstack
    end
})

-- Electronics

minetest.register_craftitem("elepower_dynamics:wound_copper_coil", {
    description = S("Wound Copper Coil") .. "\n" .. S("Tier @1 Coil", "1"),
    inventory_image = "elepower_copper_coil.png",
    groups = {copper = 1, coil = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:wound_silver_coil", {
    description = S("Wound Silver Coil") .. "\n" .. S("Tier @1 Coil", "2"),
    inventory_image = "elepower_silver_coil.png",
    groups = {silver = 1, coil = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:induction_coil", {
    description = S("Induction Coil") .. "\n" .. S("Tier @1 Coil", "3"),
    inventory_image = "elepower_induction_coil.png",
    groups = {induction_coil = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:induction_coil_advanced", {
    description = S("Advanced Induction Coil") .. "\n" ..
        S("Suitable for high-power applications") .. "\n" ..
        S("Tier @1 Coil", "4"),
    inventory_image = "elepower_induction_coil_advanced.png",
    groups = {induction_coil = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:chip", {
    description = S("Chip") .. "\n" .. S("Tier @1 Chip", "1"),
    inventory_image = "elepower_chip.png",
    groups = {chip = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:microcontroller", {
    description = S("Microcontroller") .. "\n" .. S("Tier @1 Chip", "2"),
    inventory_image = "elepower_microcontroller.png",
    groups = {chip = 2, component = 1}
})

minetest.register_craftitem("elepower_dynamics:soc", {
    description = S("System on a Chip (SoC)") .. "\n" .. S("Tier @1 Chip", "3"),
    inventory_image = "elepower_soc.png",
    groups = {chip = 3, component = 1}
})

minetest.register_craftitem("elepower_dynamics:capacitor", {
    description = S("Capacitor") .. "\n" .. S("Tier @1 Capacitor", "1"),
    inventory_image = "elepower_capacitor.png",
    groups = {capacitor = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:uv_bulb", {
    description = S("Ultraviolet Light Bulb"),
    inventory_image = "elepower_uv_bulb.png",
    groups = {component = 1, bulb = 1}
})

-- Assembled Components

minetest.register_craftitem("elepower_dynamics:battery", {
    description = S("Battery"),
    inventory_image = "elepower_battery.png",
    groups = {battery = 1, component = 1}
})

minetest.register_craftitem("elepower_dynamics:servo_valve", {
    description = S("Servo Valve"),
    inventory_image = "elepower_servo_valve.png",
    groups = {servo_valve = 1, assembled_component = 1}
})

minetest.register_craftitem("elepower_dynamics:integrated_circuit", {
    description = S("Integrated Circuit") .. "\n" .. S("Tier @1 Circuit", "1"),
    inventory_image = "elepower_ic.png",
    groups = {circuit = 1, assembled_component = 1}
})

minetest.register_craftitem("elepower_dynamics:control_circuit", {
    description = S("Integrated Control Circuit") .. "\n" ..
        S("Tier @1 Circuit", "2"),
    inventory_image = "elepower_ic_2.png",
    groups = {circuit = 2, assembled_component = 1, control_circuit = 1}
})

minetest.register_craftitem("elepower_dynamics:micro_circuit", {
    description = S("Microcontroller Circuit") .. "\n" ..
        S("Tier @1 Circuit", "3"),
    inventory_image = "elepower_ic_3.png",
    groups = {circuit = 3, assembled_component = 1, control_circuit = 2}
})

minetest.register_craftitem("elepower_dynamics:lcd_panel", {
    description = S("LCD Panel"),
    inventory_image = "elepower_lcd_panel.png",
    groups = {lcd = 1, assembled_component = 1}
})

minetest.register_craftitem("elepower_dynamics:pv_cell", {
    description = S("Photovoltaic Cell"),
    inventory_image = "elepower_pv_cell.png",
    groups = {pv = 1, assembled_component = 1}
})
