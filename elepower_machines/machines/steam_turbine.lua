
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec

local function get_formspec(power, percent, buffer, state)
	local start, _, by, mx, _, center_x = efs.begin(11.75, 10.45)
	return start..
		efs.power_meter(power)..
		efs.state_switcher(center_x, by + 1.25, state)..
		efs.fluid_bar(mx - 1, by, buffer)..
		epr.gui_player_inv()
end

ele.register_fluid_generator("elepower_machines:steam_turbine", {
	description = "Steam Turbine",
	ele_usage = 128,
	ele_output = 128,
	tiles = {
		"elepower_machine_top.png^elepower_power_port.png", "elepower_machine_base.png", "elepower_machine_side.png",
		"elepower_machine_side.png", "elepower_machine_side.png^elepower_turbine_side.png", "elepower_machine_side.png^elepower_turbine_side.png",
	},
	ele_active_node = true,
	ele_active_nodedef = {
		tiles = {
			"elepower_machine_top.png^elepower_power_port.png", "elepower_machine_base.png", "elepower_machine_side.png",
			"elepower_machine_side.png", "elepower_machine_side.png^elepower_turbine_side.png", "elepower_machine_side.png^elepower_turbine_side.png",
		},
	},
	fluid_buffers = {
		steam = {
			capacity  = 8000,
			accepts   = {"elepower_dynamics:steam"},
			drainable = false
		}
	},
	tube = false,
	ele_no_automatic_ports = true,
	fuel_burn_time = 2,
	get_formspec = get_formspec,
})
