-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local epg = ele.external.graphic
local epi = ele.external.ing
local efs = ele.formspec

local TIME = 5

local cooler_recipes = {
	[epi.cobble] = {
		lava  = 0,
		water = 0,
	},
	[epi.obsidian] = {
		lava  = 1000,
		water = 0,
	},
	[epi.stone] = {
		lava  = 0,
		water = 1000,
	},
}

local function get_formspec(item_percent, coolant_buffer, hot_buffer, power, recipes, recipe, state)
	local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)
	local rclist = {}

	local x = center_x - efs.move(math.ceil(#recipes / 2) + 1)
	for j in pairs(recipes) do
		if j == recipe then
			rclist[#rclist + 1] = "item_image["..x..","..by..";1,1;"..j.."]"
		else
			rclist[#rclist + 1] = "item_image_button[".. x ..","..by..";1,1;"..j..";"..j..";]"
		end
		x = x + 1.25
	end

	return start..
		efs.power_meter(power) ..
		efs.state_switcher(center_x, by + 2.5, state) ..
		efs.fluid_bar(bx + 1.25, by, coolant_buffer) ..
		efs.fluid_bar(mx - 1, by, hot_buffer) ..
		efs.list("context", "dst", center_x, by + 1.25, 1, 1) ..
		efs.image(center_x - 1.25, by + 1.25, 1, 1, epg.gui_furnace_arrow_bg.."^[lowpart:"..
		(item_percent)..":"..epg.gui_furnace_arrow_fg.."^[transformR270") ..
		efs.image(center_x + 1.25, by + 1.25, 1, 1, epg.gui_furnace_arrow_bg.."^[lowpart:"..
		(item_percent)..":"..epg.gui_furnace_arrow_fg.."^[transformFXR90") ..
		table.concat(rclist, "")..
		epr.gui_player_inv() ..
		"listring[current_player;main]"..
		"listring[context;dst]"..
		"listring[current_player;main]"
end

local function lava_cooler_timer(pos, elapsed)
	local refresh = false

	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()

	local coolant_buffer = fluid_lib.get_buffer_data(pos, "coolant")
	local hot_buffer     = fluid_lib.get_buffer_data(pos, "hot")

	local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
	local usage    = ele.helpers.get_node_property(meta, pos, "usage")
	local storage  = ele.helpers.get_node_property(meta, pos, "storage")

	local recipe  = meta:get_string("recipe")
	local consume = cooler_recipes[recipe]
	local time    = meta:get_int("src_time")
	local active  = "Active"

	local state = meta:get_int("state")
	local is_enabled = ele.helpers.state_enabled(meta, pos, state)

	local power = {capacity = capacity, storage = storage, usage = 0}

	if storage > usage and is_enabled then
		if coolant_buffer.amount >= 1000 and hot_buffer.amount >= 1000 then
			if time >= TIME then
				local room_for_output = true
				local output_stacks   = {recipe}
				inv:set_size("dst_tmp", inv:get_size("dst"))
				inv:set_list("dst_tmp", inv:get_list("dst"))

				for _, o in ipairs(output_stacks) do
					if not inv:room_for_item("dst_tmp", o) then
						room_for_output = false
						break
					end
					inv:add_item("dst_tmp", o)
				end

				if room_for_output then
					inv:set_list("dst", inv:get_list("dst_tmp"))
					time = 0
					refresh = true
					fluid_lib.take_from_buffer(pos, "coolant", consume.water)
					fluid_lib.take_from_buffer(pos, "hot", consume.lava)
				end
			else
				time    = time + 1
				storage = storage - usage
				power.usage = usage
				refresh = true
			end
		else
			active = "Idle"
			refresh = false
		end
	elseif not is_enabled then
		active = "Off"
	else
		active = "Idle"
	end

	local timer = math.floor(100 * time / TIME)

	meta:set_int("src_time", time)
	meta:set_int("storage", storage)
	meta:set_string("infotext", ("Lava Cooler %s\n%s"):format(active, ele.capacity_text(capacity, storage)))

	meta:set_string("formspec", get_formspec(timer, coolant_buffer, hot_buffer, 
		power, cooler_recipes, recipe, state))

	return refresh
end

ele.register_machine("elepower_machines:lava_cooler", {
	description = "Lava Cooler",
	groups = {ele_machine = 1, ele_user = 1, cracky = 2, oddly_breakable_by_hand = 1, fluid_container = 1},
	fluid_buffers = {
		coolant = {
			capacity = 8000,
			accepts  = {epi.water_source},
		},
		hot = {
			capacity = 8000,
			accepts  = {epi.lava_source},
		}
	},
	tiles = {
		"elepower_machine_top.png", "elepower_machine_base.png", "elepower_machine_side.png",
		"elepower_machine_side.png", "elepower_machine_side.png", "elepower_machine_side.png^elepower_lava_cooler.png",
	},
	on_construct = function (pos)
		local meta = minetest.get_meta(pos)
		local inv  = meta:get_inventory()

		inv:set_size("dst", 1)

		meta:set_string("recipe", epi.cobble)
		meta:set_string("formspec", get_formspec(0,nil,nil,nil,cooler_recipes, epi.cobble))
	end,
	on_timer = lava_cooler_timer,
	on_receive_fields = function (pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		local frecipe = nil

		for f in pairs(fields) do
			if cooler_recipes[f] then
				frecipe = f
				break
			end
		end

		if frecipe then
			meta:set_string("recipe", frecipe)
			ele.helpers.start_timer(pos)
		end
	end,
})
