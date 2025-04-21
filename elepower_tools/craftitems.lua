local S = ele.translator

minetest.register_craftitem("elepower_tools:drill_bit", {
	description = S("Drill Bit"),
	inventory_image = "eletools_drill_bit.png",
})

minetest.register_craftitem("elepower_tools:chain", {
	description = S("Chainsaw Chain"),
	inventory_image = "eletools_chain.png",
})

minetest.register_craftitem("elepower_tools:repair_core", {
	description = S("Repair Core"),
	inventory_image = "eletools_repair_core.png",
	stack_max = 1,
})
