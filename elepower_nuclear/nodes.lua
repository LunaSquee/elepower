
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epg = ele.external.graphic
local eps = ele.external.sounds

minetest.register_node("elepower_nuclear:machine_block", {
	description = "Radiation-shielded Lead Machine Chassis\nContains dangerous ionizing radiation",
	tiles = {
		"elenuclear_machine_top.png", "elepower_lead_block.png", "elenuclear_machine_block.png",
		"elenuclear_machine_block.png", "elenuclear_machine_block.png", "elenuclear_machine_block.png",
	},
	groups = {cracky = 3},
	_mcl_blast_resistance = 4,
	_mcl_hardness = 4,
})

minetest.register_node("elepower_nuclear:stone_with_uranium", {
	description = "Uranium Ore",
	tiles = {epg.stone.."^elenuclear_mineral_uranium.png"},
	groups = {cracky = 2, pickaxey = 4, material_stone = 1},
	drop = 'elepower_nuclear:uranium_lump',
	sounds = eps.node_sound_stone,
	_mcl_blast_resistance = 3,
	_mcl_hardness = 3,
	_mcl_silk_touch_drop = true,
})

minetest.register_node("elepower_nuclear:fusion_coil", {
	description = "Fusion Reactor Coil",
	tiles       = {"elenuclear_fusion_coil_top.png", "elenuclear_fusion_coil_top.png", "elenuclear_fusion_coil_side.png"},
	groups      = {cracky = 2},
	_mcl_blast_resistance = 4,
	_mcl_hardness = 4,
})

dofile(elenuclear.modpath.."/machines/init.lua")
