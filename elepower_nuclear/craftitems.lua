local S = ele.translator

---------------------------
-- Fission-related items --
---------------------------

-- Uranium

minetest.register_craftitem("elepower_nuclear:uranium_lump", {
	description = S("Uranium Lump"),
	inventory_image = "elenuclear_uranium_lump.png"
})

-- Dusts

minetest.register_craftitem("elepower_nuclear:uranium_dust", {
	description = S("Enriched Uranium Dust") .. "\n" .. S("Ready to be used as fuel"),
	inventory_image = "elepower_dust.png^[colorize:#3eff2788^[multiply:#3eff27A0"
})

minetest.register_craftitem("elepower_nuclear:depleted_uranium_dust", {
	description = S("Depleted Uranium Dust") .. "\n" .. S("Requires enrichment"),
	inventory_image = "elepower_dust.png^[multiply:#18df00"
})

minetest.register_craftitem("elepower_nuclear:nuclear_waste", {
	description = S("Nuclear Waste") .. "\n" .. S("Mostly unusable for nuclear fission"),
	inventory_image = "elenuclear_uranium_waste.png"
})

-- Fuel rods

minetest.register_craftitem("elepower_nuclear:fuel_rod_empty", {
	description = S("Empty Fuel Rod"),
	inventory_image = "elenuclear_fuel_rod_empty.png",
	stack_max = 1,
})

minetest.register_craftitem("elepower_nuclear:fuel_rod_fissile", {
	description = S("Fissile Fuel Rod") .. "\n" .. S("Lasts @1 hours (@2 seconds)", "2", "7200"),
	inventory_image = "elenuclear_fuel_rod_fissile.png",
	groups = { fissile_fuel = 1 },
	fissile_count = 7200,
	stack_max = 1,
})

minetest.register_craftitem("elepower_nuclear:fuel_rod_depleted", {
	description = S("Depleted Fuel Rod") .. "\n" .. S("Can not be used in a reactor anymore"),
	inventory_image = "elenuclear_fuel_rod_depleted.png",
	stack_max = 1,
})

-- Control rods

minetest.register_craftitem("elepower_nuclear:control_rod", {
	description = S("Control Rod"),
	inventory_image = "elenuclear_control_rod.png",
	stack_max = 4,
})

minetest.register_craftitem("elepower_nuclear:control_rod_assembly", {
	description = S("Control Rod Assembly"),
	inventory_image = "elenuclear_control_rod_assembly.png",
	stack_max = 1,
})

minetest.register_craftitem("elepower_nuclear:control_plate", {
	description = S("Perforated Control Plate"),
	inventory_image = "elenuclear_control_plate.png",
	stack_max = 1,
})

-- Pressure vessel

minetest.register_craftitem("elepower_nuclear:pressure_vessel", {
	description = S("Reactor Pressure Vessel"),
	inventory_image = "elenuclear_pressure_vessel.png",
	stack_max = 1,
})

--------------------------
-- Fusion-related items --
--------------------------



-------------------------
-- Crafting components --
-------------------------
