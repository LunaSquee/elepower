
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epi = ele.external.ing
local epg = ele.external.graphic
local efs = ele.formspec
local S = ele.translator

local function get_formspec(heat, cold, water, steam)
	local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)
	return start..
		efs.fluid_bar(bx, by, heat)..
		efs.fluid_bar(bx + 1.25, by, cold)..
		efs.image(center_x, by + 1.25, 1, 1, epg.gui_furnace_arrow_bg.."^[transformR270]")..
		efs.fluid_bar(mx - 1, by, water)..
		efs.fluid_bar(mx - 2.25, by, steam)..
		epr.gui_player_inv() ..
		"listring[current_player;main]"
end

local heat_recipes = {
	["elepower_nuclear:hot_coolant_source"] = {
		out = "elepower_nuclear:coolant_source",
		factor = 8,
	},
	["elepower_nuclear:helium_plasma"] = {
		out = "elepower_nuclear:helium",
		factor = 32,
	},
}

local function heat_exchanger_timer(pos)
	local meta = minetest.get_meta(pos)
	local change = false

	local heat  = fluid_lib.get_buffer_data(pos, "heat")
	local cold  = fluid_lib.get_buffer_data(pos, "cold")
	local water = fluid_lib.get_buffer_data(pos, "water")
	local steam = fluid_lib.get_buffer_data(pos, "steam")

	while true do
		if heat.fluid == "" or not heat_recipes[heat.fluid] then
			break
		end

		-- Convert a maximum of 1000 buckets of hot fluid per second
		local heatper = 1000
		if heat.amount < 1000 then
			heatper = heat.amount
		end

		-- See if we have enough hot coolant
		if heatper > 0 and heat.fluid ~= "" then
			local damnt = heat_recipes[heat.fluid]
			local water_convert = math.min(water.amount, heatper * damnt.factor)

			if cold.fluid ~= damnt.out and cold.fluid ~= "" then
				break
			end

			if steam.amount + water_convert > steam.capacity then
				water_convert = steam.capacity - steam.amount
			end

			if water_convert > 0 and cold.amount + heatper <= cold.capacity then
				-- Conversion
				heat.amount = heat.amount - heatper
				cold.amount = cold.amount + heatper

				water.amount = water.amount - water_convert
				steam.amount = steam.amount + water_convert

				cold.fluid = damnt.out
				change = true
			end
		end

		if heat.fluid ~= "" and heat.amount == 0 then
			heat.fluid = ""
			change = true
		end

		if cold.fluid ~= "" and cold.amount == 0 then
			cold.fluid = ""
			change = true
		end

		break
	end

	if change then
		meta:set_string("heat_fluid", heat.fluid)
		meta:set_string("cold_fluid", cold.fluid)
		meta:set_string("steam_fluid", "elepower_dynamics:steam")

		meta:set_int("heat_fluid_storage", heat.amount)
		meta:set_int("cold_fluid_storage", cold.amount)

		meta:set_int("water_fluid_storage", water.amount)
		meta:set_int("steam_fluid_storage", steam.amount)
	end

	meta:set_string("formspec", get_formspec(heat, cold, water, steam))

	return change
end

ele.register_machine("elepower_nuclear:heat_exchanger", {
	description = S("Shielded Heat Exchanger") .. "\n" .. S("For use in nuclear power plants"),
	tiles = {
		"elenuclear_machine_top.png",  "elepower_lead_block.png",  "elenuclear_machine_side.png",
		"elenuclear_machine_side.png", "elenuclear_machine_side.png", "elenuclear_heat_exchanger.png",
	},
	groups = {cracky = 2, pickaxey = 2, fluid_container = 1},
	fluid_buffers = {
		heat = {
			capacity  = 16000,
			accepts   = {"elepower_nuclear:hot_coolant_source", "elepower_nuclear:helium_plasma"},
			drainable = false,
		},
		cold = {
			capacity  = 16000,
			accepts   = {"elepower_nuclear:coolant_source", "elepower_nuclear:helium"},
			drainable = true,
		},
		water = {
			capacity  = 64000,
			accepts   = {epi.water_source},
			drainable = false,
		},
		steam = {
			capacity  = 64000,
			drainable = true,
		},
	},
	on_construct = function (pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", get_formspec())
	end,
	on_timer = heat_exchanger_timer,
})
