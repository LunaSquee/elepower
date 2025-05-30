
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local function get_formspec_default(power, percent, buffer, state)
	local start, bx, by, mx = efs.begin(11.75, 10.45)
	local cx, cy = efs.center_in_box(11.75, 5, 1, 1)
	return start..
		efs.power_meter(power) ..
		efs.state_switcher(mx - 1, by + 3, state) ..
		efs.fluid_bar(mx - 1, by, buffer) ..
		efs.fuel(cx, cy, percent) ..
		epr.gui_player_inv()
end

-- A generator that creates power using a fuel
function ele.register_fluid_generator(nodename, nodedef)
	local btime  = nodedef.fuel_burn_time or 8
	local busage = nodedef.fuel_usage or 1000
	local buffer_name = nil

	-- Autodetect fluid buffer and the fuel if necessary
	if not nodedef.fluid_buffers then return nil end
	for buf,data in pairs(nodedef.fluid_buffers) do
		buffer_name = buf
		break
	end

	-- Allow for custom formspec
	local get_formspec = get_formspec_default
	if nodedef.get_formspec then
		get_formspec = nodedef.get_formspec
		nodedef.get_formspec = nil
	end

	local defaults = {
		groups = {
			fluid_container = 1,
			ele_provider = 1,
			oddly_breakable_by_hand = 1,
		},
		ele_upgrades = {
			capacitor = {"capacity"},
		},
		tube = false,
		on_timer = function (pos, elapsed)
			local refresh  = false
			local meta     = minetest.get_meta(pos)

			local burn_time      = meta:get_int("burn_time")
			local burn_totaltime = meta:get_int("burn_totaltime")

			local capacity   = ele.helpers.get_node_property(meta, pos, "capacity")
			local generation = ele.helpers.get_node_property(meta, pos, "usage")
			local storage    = ele.helpers.get_node_property(meta, pos, "storage")

			local state = meta:get_int("state")
			local is_enabled = ele.helpers.state_enabled(meta, pos, state)

			-- Fluid buffer
			local flbuffer = fluid_lib.get_buffer_data(pos, buffer_name)
			local pow_buffer = {capacity = capacity, storage = storage, usage = 0}
			local status = S("Idle")

			while true do
				if not is_enabled then
					status = S("Off")
					break
				end

				-- If more to burn and the energy produced was used: produce some more
				if burn_time > 0 then
					if storage + generation > capacity then
						break
					end

					pow_buffer.storage = pow_buffer.storage + generation
					pow_buffer.usage = generation

					burn_time = burn_time - 1
					meta:set_int("burn_time", burn_time)

					refresh = true
				end

				status = S("Active")

				-- Burn another bucket of fluid fuel
				if burn_time == 0 then
					if not flbuffer or flbuffer.fluid == "" then break end

					local inv = meta:get_inventory()
					if flbuffer.amount >= busage then
						meta:set_int("burn_time", btime)
						meta:set_int("burn_totaltime", btime)

						-- Take fluid fuel
						flbuffer.amount = flbuffer.amount - busage
						pow_buffer.usage = generation

						if nodedef.ele_active_node then
							local active_node = nodename .. "_active"
							if nodedef.ele_active_node ~= true then
								active_node = nodedef.ele_active_node
							end

							ele.helpers.swap_node(pos, active_node)
						end

						refresh = true
					else
						status = S("Idle")
						ele.helpers.swap_node(pos, nodename)

						refresh = false
					end
				end
				if burn_totaltime == 0 then burn_totaltime = 1 end
				if flbuffer.fluid ~= "" and flbuffer.amount == 0 then flbuffer.fluid = "" end
				break
			end

			local percent = math.floor((burn_time / burn_totaltime) * 100)
			meta:set_string("formspec", get_formspec(pow_buffer, percent, flbuffer, state))
			meta:set_string("infotext", ("%s %s\n%s\n%s"):format(nodedef.description, status,
				ele.capacity_text(capacity, pow_buffer.storage), fluid_lib.buffer_to_string(flbuffer)))

			meta:set_string(buffer_name .. "_fluid", flbuffer.fluid)
			meta:set_int(buffer_name .. "_fluid_storage", flbuffer.amount)
			meta:set_int("storage", pow_buffer.storage)

			return refresh
		end,
		on_construct = function (pos)
			local meta = minetest.get_meta(pos)

			local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
			local storage  = ele.helpers.get_node_property(meta, pos, "storage")

			meta:set_string("formspec", get_formspec({capacity = capacity, storage = storage, usage = 0}, 0))
		end
	}

	nodedef.fuel_burn_time = nil
	nodedef.fuel_usage = nil

	for key,val in pairs(defaults) do
		if not nodedef[key] then
			nodedef[key] = val
		end
	end

	ele.register_machine(nodename, nodedef)
end
