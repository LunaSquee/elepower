
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local recipes = {
	{
		input  = "elepower_dynamics:lithium_gas 100",
		output = "elepower_nuclear:tritium 20",
		time   = 5,
	}
}

local function get_recipe(input)
	local recipe = {time = 0}
	for _,r in pairs(recipes) do
		local istack = ItemStack(r.input)
		if input.amount >= istack:get_count() and input.fluid == istack:get_name() then
			recipe = {
				input  = istack,
				output = ItemStack(r.output),
				time   = r.time,
			}
			break
		end
	end
	return recipe
end

local function get_formspec(inp, outp, solar, percent)
	local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)

	return start..
		efs.fluid_bar(bx, by, inp) ..
		efs.progress(center_x, by + 1.25, percent) ..
		efs.label(center_x, by + 1, S("Light: @1", solar.."%")) ..
		efs.fluid_bar(mx - 1, by, outp) ..
		epr.gui_player_inv() ..
		"listring[current_player;main]"
end

local function on_timer (pos, elapsed)
	local meta = minetest.get_meta(pos)
	local refresh = true

	local inp  = fluid_lib.get_buffer_data(pos, "input")
	local outp = fluid_lib.get_buffer_data(pos, "output")

	local recipe = get_recipe(inp)
	local status = S("Idle")

	local time     = meta:get_int("src_time")
	local time_res = meta:get_int("src_time_max")
	local solarp   = 0

	while true do
		if recipe.time == 0 then
			refresh = false
			break
		end

		time_res = recipe.time
		local result_t = recipe.output:get_count()
		local input_t = recipe.input:get_count()

		if result_t + outp.amount > outp.capacity or (outp.fluid ~= recipe.output:get_name() and outp.fluid ~= "") then
			status = S("Output Full!")
			refresh = false
			break
		end

		local pos1 = vector.add(pos, {x=0,y=1,z=0})
		local light = minetest.get_node_light(pos1, nil) or 0
		local time_of_day = minetest.get_timeofday()

		solarp = light / (minetest.LIGHT_MAX + 1)

		if light >= 12 and time_of_day >= 0.24 and time_of_day <= 0.76 then
			status = S("Active")

			time = time + 1
			outp.amount = outp.amount + result_t * solarp
			inp.amount = inp.amount - input_t * solarp
			outp.fluid = recipe.output:get_name()
		else
			status = S("Not enough light!")
		end

		if time >= time_res then
			time = 0
		end

		break
	end

	if inp.amount == 0 then
		inp.fluid = ""
	end

	meta:set_string("input_fluid", inp.fluid)
	meta:set_int("input_fluid_storage", inp.amount)

	meta:set_string("output_fluid", outp.fluid)
	meta:set_int("output_fluid_storage", outp.amount)

	meta:set_int("src_time", time)
	meta:set_int("src_time_max", time_res)

	local pcrt = 0
	if time_res > 0 then
		pcrt = math.floor(100 * time / time_res)
	end

	meta:set_string("infotext", S("Solar Neutron Activator") .. " " .. status)
	meta:set_string("formspec", get_formspec(inp, outp, solarp * 100, pcrt))
	return refresh
end

ele.register_base_device("elepower_nuclear:solar_neutron_activator", {
	description = S("Solar Neutron Activator"),
	drawtype = "mesh",
	mesh = "elenuclear_solar_activator.obj",
	tiles = {"elenuclear_solar_activator.png"},
	paramtype2 = "facedir",
	fluid_buffers = {
		input = {
			capacity  = 8000,
			accepts   = {"elepower_dynamics:lithium_gas"},
			drainable = false,
		},
		output = {
			capacity  = 8000,
			drainable = true,
		},
	},
	groups = {fluid_container = 1, oddly_breakable_by_hand = 1},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.3750, 0.5000, -0.3750, 0.3750, 1.188, 0.3750},
			{-0.5000, -0.5000, -0.5000, 0.5000, 0.5000, 0.5000}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3750, 0.5000, -0.3750, 0.3750, 1.188, 0.3750},
			{-0.5000, -0.5000, -0.5000, 0.5000, 0.5000, 0.5000}
		}
	},
	on_timer = on_timer,
	on_punch = function (pos, node, puncher, pointed_thing)
		ele.helpers.start_timer(pos)
		minetest.node_punch(pos, node, puncher, pointed_thing)
	end,
	on_construct = function (pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", get_formspec(nil, nil, 0))
	end
})
