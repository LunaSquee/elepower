
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec

-- Nuclear fuel enrichment plant

local function get_formspec(craft_type, power, progress, pos)
	local start, _, by, mx, _, center_x = efs.begin(11.75, 10.45)
	if not progress then progress = 0 end
	return start..
		efs.power_meter_v2(power)..
		efs.list("context", "src", center_x - 1.25, by + 1.25, 1, 1) ..
		efs.fuel(center_x, by + 1.25, progress, "elenuclear_gui_icon_bg.png", "elenuclear_gui_icon_fg.png") ..
		efs.list("context", "dst", center_x + 2.25, by + 0.675, 2, 2) ..
		epr.gui_player_inv() ..
		efs.image(mx - 1, by + 3.5, 1, 1, "elenuclear_radioactive.png") ..
		"listring[current_player;main]"..
		"listring[context;src]"..
		"listring[current_player;main]"..
		"listring[context;dst]"..
		"listring[current_player;main]"
end

elepm.register_craft_type("enrichment", {
	description = "Enrichment",
	inputs      = 1,
	icon        = "elenuclear_enrichment_plant.png",
})

elepm.register_crafter("elepower_nuclear:enrichment_plant", {
	description = "Enrichment Plant",
	craft_type = "enrichment",
	tiles = {
		"elenuclear_machine_top.png",  "elepower_lead_block.png",  "elenuclear_machine_side.png",
		"elenuclear_machine_side.png", "elenuclear_machine_side.png", "elenuclear_enrichment_plant.png",
	},
	groups = {ele_user = 1, cracky = 3},
	ele_capacity = 8000,
	ele_usage    = 1000,
	ele_inrush   = 8000,
	get_formspec = get_formspec,
})
