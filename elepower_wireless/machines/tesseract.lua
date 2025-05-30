local S = ele.translator

minetest.register_node("elepower_wireless:tesseract_frame", {
	description = S("Tesseract Frame"),
	tiles = {
		"elewireless_tesseract.png",
	},
	use_texture_alpha = "clip",
	groups = {cracky = 2, pickaxey = 2},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.3125, -0.3125, 0.5}, -- NodeBox1
			{0.3125, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox2
			{-0.5, 0.3125, -0.5, -0.3125, 0.5, 0.5}, -- NodeBox3
			{0.3125, 0.3125, -0.5, 0.5, 0.5, 0.5}, -- NodeBox4
			{-0.3125, -0.5, -0.5, 0.3125, -0.3125, -0.3125}, -- NodeBox5
			{-0.3125, -0.5, 0.3125, 0.3125, -0.3125, 0.5}, -- NodeBox6
			{-0.3125, 0.3125, 0.3125, 0.3125, 0.5, 0.5}, -- NodeBox7
			{-0.3125, 0.3125, -0.5, 0.3125, 0.5, -0.3125}, -- NodeBox8
			{-0.5, -0.3125, -0.5, -0.3125, 0.3125, -0.3125}, -- NodeBox9
			{-0.5, -0.3125, 0.3125, -0.3125, 0.3125, 0.5}, -- NodeBox10
			{0.3125, -0.5, 0.3125, 0.5, 0.5, 0.5}, -- NodeBox11
			{0.3125, -0.3125, -0.5, 0.5, 0.3125, -0.3125}, -- NodeBox12
		}
	}
})

minetest.register_node("elepower_wireless:tesseract", {
	description = S("Tesseract"),
	tiles = {
		"elewireless_tesseract.png",
	},
	groups = {cracky = 2, pickaxey = 2},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.3125, -0.3125, 0.5}, -- NodeBox1
			{0.3125, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox2
			{-0.5, 0.3125, -0.5, -0.3125, 0.5, 0.5}, -- NodeBox3
			{0.3125, 0.3125, -0.5, 0.5, 0.5, 0.5}, -- NodeBox4
			{-0.3125, -0.5, -0.5, 0.3125, -0.3125, -0.3125}, -- NodeBox5
			{-0.3125, -0.5, 0.3125, 0.3125, -0.3125, 0.5}, -- NodeBox6
			{-0.3125, 0.3125, 0.3125, 0.3125, 0.5, 0.5}, -- NodeBox7
			{-0.3125, 0.3125, -0.5, 0.3125, 0.5, -0.3125}, -- NodeBox8
			{-0.5, -0.3125, -0.5, -0.3125, 0.3125, -0.3125}, -- NodeBox9
			{-0.5, -0.3125, 0.3125, -0.3125, 0.3125, 0.5}, -- NodeBox10
			{0.3125, -0.5, 0.3125, 0.5, 0.5, 0.5}, -- NodeBox11
			{0.3125, -0.3125, -0.5, 0.5, 0.3125, -0.3125}, -- NodeBox12
			{-0.3125, -0.3125, -0.3125, 0.3125, 0.3125, 0.3125}, -- NodeBox13
		}
	}
})

