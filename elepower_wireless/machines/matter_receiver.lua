
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec

elewi.loaded_receivers = {}

local function get_formspec(power, name, player)
	local start, bx, by = efs.begin(11.75, 10.45)
	return start..
		efs.power_meter(power)..
		efs.field(bx + 1.25, by + 0.25, 5, 0.5, "name", "Receiver Name", name) ..
		efs.label(bx, by + 3.75, "Owned by " .. player) ..
		epr.gui_player_inv()..
		"field_close_on_enter[name;false]"..
		"listring[current_player;main]"
end

local function matter_receiver_timer(pos)
	local meta   = minetest.get_meta(pos)
	local name   = meta:get_string("name")
	local player = meta:get_string("player")

	if name == "" then
		name = "Matter Receiver"
	end

	local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
	local storage  = ele.helpers.get_node_property(meta, pos, "storage")
	local usage    = ele.helpers.get_node_property(meta, pos, "usage")

	local pow_percent = {capacity = capacity, storage = storage, usage = usage}

	if storage >= usage then
		ele.helpers.swap_node(pos, "elepower_wireless:matter_receiver_active")
	else
		ele.helpers.swap_node(pos, "elepower_wireless:matter_receiver")
	end

	meta:set_string("formspec", get_formspec(pow_percent, name, player))
	meta:set_string("infotext", name .. "\n" .. ele.capacity_text(capacity, storage))

	return false
end

local function save_receiver(pos)
	local strname = minetest.pos_to_string(pos)

	if elewi.loaded_receivers[strname] then return end

	local meta   = minetest.get_meta(pos)
	local name   = meta:get_string("name")
	local player = meta:get_string("player")

	if name == "" then
		name = "Matter Receiver"
	end

	elewi.loaded_receivers[strname] = {
		name   = name,
		player = player,
	}
end

ele.register_machine("elepower_wireless:matter_receiver", {
	description = "Matter Receiver",
	tiles = {
		"elewireless_teleport_top.png", "elewireless_device_side.png^elepower_power_port.png", "elewireless_device_side.png",
		"elewireless_device_side.png", "elewireless_device_side.png", "elewireless_device_side.png"
	},
	drawtype = "nodebox",
	node_box = elewi.slab_nodebox,
	ele_active_node = true,
	ele_active_nodedef = {
		tiles = {
			{
				name = "elewireless_receiver_top_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					speed = 5,
				},
			},
			"elewireless_device_side.png^elepower_power_port.png", "elewireless_device_side.png",
			"elewireless_device_side.png", "elewireless_device_side.png", "elewireless_device_side.png"
		},
	},
	use_texture_alpha = "clip",
	groups = {cracky = 1, ele_user = 1, matter_receiver = 1},
	ele_capacity = 8000,
	ele_usage    = 120,
	ele_inrush   = 240,
	ele_no_automatic_ports = true,
	on_timer = matter_receiver_timer,
	after_place_node = function (pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		if not placer or placer:get_player_name() == "" then return false end

		meta:set_string("player", placer:get_player_name())
		save_receiver(pos)
	end,
	on_receive_fields = function (pos, formname, fields, sender)
		if sender and sender ~= "" and minetest.is_protected(pos, sender:get_player_name()) then
			return
		end

		-- Set Name
		local meta = minetest.get_meta(pos)
		if fields["name"] and fields["key_enter"] == "true" then
			meta:set_string("name", fields["name"])
			minetest.get_node_timer(pos):start(0.2)

			local strname = minetest.pos_to_string(pos)
			if not elewi.loaded_receivers[strname] then return end
			elewi.loaded_receivers[strname].name = fields["name"]
		end
	end,
	after_destruct = function (pos)
		local strname = minetest.pos_to_string(pos)
		if not elewi.loaded_receivers[strname] then return end
		elewi.loaded_receivers[strname] = nil
	end,
})

minetest.register_lbm({
    label = "Load Receiver into memory",
    name = "elepower_wireless:matter_receiver",
    nodenames = {"group:matter_receiver"},
    run_at_every_load = true,
    action = save_receiver,
})
