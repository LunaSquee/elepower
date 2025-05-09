
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local function get_formspec(fuel_percent, item_percent)
	local start, bx, by, mx = efs.begin(11.75, 10.45)

	local pad_start = by + 0.25
	local input_x = bx + 2.25
	local fuel_x = bx + 2.875
	local fuel_y = pad_start + 1.25
	local fuel_slot = fuel_y + 1.25
	local output_x = mx - 4
	local output_y = fuel_y - 0.625
	local arrow_x = fuel_x + input_x - 0.25

	return start ..
		efs.list("context", "src", input_x, pad_start, 2, 1) ..
		efs.list("context", "fuel", fuel_x, fuel_slot, 1, 1) ..
		efs.fuel(fuel_x, fuel_y, fuel_percent) ..
		efs.progress(arrow_x, fuel_y, item_percent) ..
		efs.list("context", "dst", output_x, output_y, 2, 2) ..
		epr.gui_player_inv() ..
		"listring[context;dst]"..
		"listring[current_player;main]"..
		"listring[context;src]"..
		"listring[current_player;main]"..
		"listring[context;fuel]"..
		"listring[current_player;main]"
end

local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src")
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time == 0 then
			return 0
		end
	elseif listname == "dst" then
		return 0
	end
	
	return stack:get_count()
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function alloy_furnace_timer(pos, elapsed)
	--
	-- Inizialize metadata
	--
	local meta = minetest.get_meta(pos)
	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local inv = meta:get_inventory()
	local srclist, fuellist

	local alloyable
	local fuel
	local time = 0

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		--
		-- Alloying
		--

		-- Check if we have alloyable content
		local alloy = elepm.get_recipe("alloy", srclist)
		local afteralloy = alloy.new_input
		alloyable = alloy.time ~= 0

		local el = math.min(elapsed, fuel_totaltime - fuel_time)
		if alloyable then -- fuel lasts long enough, adjust el to cooking duration
			time = alloy.time + 4
			el = math.min(el, time - src_time)
		end

		-- Check if we have enough fuel to burn
		if fuel_time < fuel_totaltime then
			-- The furnace is currently active and has enough fuel
			fuel_time = fuel_time + el
			-- If there is a alloyable item then check if it is ready yet
			if alloyable then
				src_time = src_time + el
				if src_time >= time then
					-- Place result in dst list if possible
					if inv:room_for_item("dst", alloy.output) then
						inv:add_item("dst", alloy.output)
						inv:set_list("src", afteralloy)
						src_time = src_time - time
						update = true
					end
				else
					-- Item could not be alloy: probably missing fuel
					update = true
				end
			end
		else
			-- Furnace ran out of fuel
			if alloyable then
				-- We need to get new fuel
				local afterfuel
				fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

				if fuel.time == 0 then
					-- No valid fuel in fuel list
					fuel_totaltime = 0
					src_time = 0
				else
					-- Take fuel from fuel list
					inv:set_stack("fuel", 1, afterfuel.items[1])
					update = true
					fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
				end
			else
				-- We don't need to get new fuel since there is no alloyable item
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - el
	end

	if fuel and fuel_totaltime > time then
		fuel_totaltime = time
	end
	if srclist[1]:is_empty() then
		src_time = 0
	end

	--
	-- Update formspec, infotext and node
	--
	local formspec
	local item_percent = 0
	if alloyable then
		item_percent = math.floor(src_time / time * 100)
	end

	local active = S("Inactive")
	local result = false

	if fuel_totaltime ~= 0 then
		active = S("Active")
		local fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		formspec = get_formspec(fuel_percent, item_percent)
		ele.helpers.swap_node(pos, "elepower_machines:coal_alloy_furnace_active")
		result = true
	else
		formspec = get_formspec(0, 0)
		ele.helpers.swap_node(pos, "elepower_machines:coal_alloy_furnace")
		minetest.get_node_timer(pos):stop()
	end

	local infotext = S("Alloy Furnace") .. " " .. active

	--
	-- Set meta values
	--
	meta:set_float("fuel_totaltime", fuel_totaltime)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)
	meta:set_string("formspec", formspec)
	meta:set_string("infotext", infotext)

	return result
end

ele.register_base_device("elepower_machines:coal_alloy_furnace", {
	description = S("Coal-fired Alloy Furnace"),
	craft_type = "alloy",
	paramtype2 = "facedir",
	ele_active_node = true,
	ele_active_nodedef = {
		tiles = {
			"elepower_cfalloy_top.png", "elepower_cfalloy_bottom.png", "elepower_cfalloy_side.png",
			"elepower_cfalloy_side.png", "elepower_cfalloy_side.png", {
				name = "elepower_cfalloy_front_active.png",
				animation = {
					aspect_h = 16,
					aspect_w = 16,
					length = 1,
					type = "vertical_frames",
				}
			}
		}
	},
	tiles = {
		"elepower_cfalloy_top.png", "elepower_cfalloy_bottom.png", "elepower_cfalloy_side.png",
		"elepower_cfalloy_side.png", "elepower_cfalloy_side.png", "elepower_cfalloy_front.png"
	},
	on_construct = function (pos)
		local meta = minetest.get_meta(pos)
		local inv  = meta:get_inventory()

		inv:set_size("src", 2)
		inv:set_size("dst", 4)
		inv:set_size("fuel", 1)

		meta:set_string("formspec", get_formspec(0, 0))
	end,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	on_metadata_inventory_move = ele.helpers.start_timer,
	on_metadata_inventory_take = ele.helpers.start_timer,
	on_metadata_inventory_put  = ele.helpers.start_timer,
	can_dig = can_dig,
	on_timer = alloy_furnace_timer,
	groups = {
		tubedevice = 1,
		tubedevice_receiver = 1,
		cracky = 2,
		pickaxey = 1,
	}
})
