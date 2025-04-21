
local S = ele.translator

minetest.register_node("elepower_farming:device_frame", {
	description = S("Plastic Device Frame") .. "\n" .. S("Safe for decoration"),
	tiles = {
		"elefarming_machine_base.png", "elefarming_machine_base.png", "elefarming_machine_side.png",
		"elefarming_machine_side.png", "elefarming_machine_side.png", "elefarming_machine_side.png",
	},
	groups = {oddly_breakable_by_hand = 1, cracky = 3, pickaxey = 1}
})
