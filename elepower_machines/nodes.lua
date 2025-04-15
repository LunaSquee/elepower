-- Nodes other than machines.

minetest.register_node("elepower_machines:machine_block", {
	description = "Machine Block\nSafe for decoration",
	tiles       = {"elepower_machine_top.png", "elepower_machine_base.png", "elepower_machine_side.png"},
	groups      = {oddly_breakable_by_hand = 1, cracky = 1},
	_mcl_blast_resistance = 2,
	_mcl_hardness = 2,
})

minetest.register_node("elepower_machines:heat_casing", {
	description = "Heat Casing",
	tiles       = {"elepower_heat_casing.png"},
	groups      = {cracky = 3, ele_evaporator_node = 1},
	_mcl_blast_resistance = 4,
	_mcl_hardness = 4,
})

minetest.register_node("elepower_machines:advanced_machine_block", {
	description = "Advanced Machine Block\nSafe for decoration",
	tiles       = {"elepower_advblock_combined.png"},
	groups      = {cracky = 3},
	_mcl_blast_resistance = 3,
	_mcl_hardness = 3,
})
