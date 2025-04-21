
-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local function escape_comma(str)
	return str:gsub(",","\\,")
end

local function get_formspec(power, player, transmitters, receivers)
	local start, bx, by, mx, _, center_x = efs.begin(11.75, 10.45)
	local width = efs.get_list_width(8)
	local offset = efs.move(3)
	local list_tr  = {}
	local tr_selct = nil
	local list_re  = {}
	local re_selct = nil

	if transmitters then
		for _,trn in pairs(transmitters) do
			local indx = #list_tr + 1
			if trn.select then
				tr_selct = indx
			end
			list_tr[indx] = trn.name .. " " .. escape_comma(trn.pos)
		end
	end

	if receivers then
		for _,rec in pairs(receivers) do
			local indx = #list_re + 1
			if rec.select then
				re_selct = indx
			end
			list_re[indx] = rec.name .. " " .. escape_comma(rec.pos)
		end
	end

	local tr_spc = ""
	if tr_selct then tr_spc = ";" .. tr_selct end

	local re_spc = ""
	if re_selct then re_spc = ";" .. re_selct end

	return start..
		efs.power_meter(power)..
		efs.textlist(center_x - offset, by, width, 1.5, "transmitter", table.concat(list_tr, ",") .. tr_spc) ..
		efs.textlist(center_x - offset, by + 1.75, width, 1.5, "receiver", table.concat(list_re, ",") .. re_spc) ..
		efs.button(mx - 2, by + 3.5, 2, 0.5, "refresh", S("Refresh")) ..
		efs.label(bx, by + 3.75, S("Owned by @1", player)) ..
		epr.gui_player_inv()..
		"listring[current_player;main]"
end

local function get_is_active_node(meta, pos)
	local storage = ele.helpers.get_node_property(meta, pos, "storage")
	local usage   = ele.helpers.get_node_property(meta, pos, "usage")
	return storage >= usage
end

local function get_transmitters_in_range(pos, player, selected, range)
	local transmitters = {}
	for spos, data in pairs(elewi.loaded_transmitters) do
		local npos = minetest.string_to_pos(spos)
		local node = minetest.get_node_or_nil(npos)
		if node and ele.helpers.get_item_group(node.name, "matter_transmitter") then
			if data.player == player and vector.distance(pos, npos) <= range then
				local meta = minetest.get_meta(npos)
				if get_is_active_node(meta, npos) then
					transmitters[#transmitters + 1] = {
						name   = data.name,
						player = player,
						pos    = spos,
						select = npos == selected,
					}
				end
			end
		end
	end
	return transmitters
end

local function get_player_receivers(player)
	local receivers = {}
	for spos, data in pairs(elewi.loaded_receivers) do
		local npos = minetest.string_to_pos(spos)
		local node = minetest.get_node_or_nil(npos)
		if node and ele.helpers.get_item_group(node.name, "matter_receiver") then
			if data.player == player then
				local meta   = minetest.get_meta(npos)
				local target = minetest.string_to_pos(meta:get_string("target"))
				if get_is_active_node(meta, npos) then
					receivers[#receivers + 1] = {
						name   = data.name,
						player = player,
						pos    = spos,
						select = target == npos,
					}
				end
			end
		end
	end
	return receivers
end

local function dialler_timer(pos)
	local meta   = minetest.get_meta(pos)
	local player = meta:get_string("player")

	local capacity = ele.helpers.get_node_property(meta, pos, "capacity")
	local storage  = ele.helpers.get_node_property(meta, pos, "storage")
	local usage    = ele.helpers.get_node_property(meta, pos, "usage")

	local transmitter = minetest.string_to_pos(meta:get_string("transmitter"))
	local pow_buffer = {capacity = capacity, storage = storage, usage = usage}

	if storage >= usage then
		ele.helpers.swap_node(pos, "elepower_wireless:dialler_active")
	else
		ele.helpers.swap_node(pos, "elepower_wireless:dialler")
	end

	local transmitters = get_transmitters_in_range(pos, player, transmitter, 8)
	local receivers    = {}
	if transmitter then
		receivers = get_player_receivers(player)
	end

	meta:set_string("formspec", get_formspec(pow_buffer, player, transmitters, receivers))
	meta:set_string("infotext", S("Dialler") .. "\n" .. ele.capacity_text(capacity, storage))

	return false
end

ele.register_machine("elepower_wireless:dialler", {
	description = S("Dialler"),
	tiles = {
		"elewireless_device_side.png", "elewireless_device_side.png", "elewireless_device_side.png",
		"elewireless_device_side.png", "elewireless_device_side.png", "elewireless_dialler_inactive.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5000, -0.5000, 0.4375, 0.5000, 0.5000, 0.5000}
		}
	},
	ele_active_node = true,
	ele_active_nodedef = {
		tiles = {
			"elewireless_device_side.png", "elewireless_device_side.png", "elewireless_device_side.png",
			"elewireless_device_side.png", "elewireless_device_side.png", "elewireless_dialler.png"
		},
	},
	use_texture_alpha = "clip",
	groups = {cracky = 2, pickaxey = 2, ele_user = 1, dialler = 1},
	ele_capacity = 8000,
	ele_usage    = 120,
	ele_inrush   = 240,
	on_timer = dialler_timer,
	after_place_node = function (pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		if not placer or placer:get_player_name() == "" then return false end

		meta:set_string("player", placer:get_player_name())
	end,
	on_receive_fields = function (pos, formname, fields, sender)
		if sender and sender ~= "" and minetest.is_protected(pos, sender:get_player_name()) then
			return
		end

		if fields["refresh"] then
			minetest.get_node_timer(pos):start(0.2)
			return
		end

		if not fields["transmitter"] and not fields["receiver"] then
			return
		end

		local meta = minetest.get_meta(pos)
		local trans = minetest.string_to_pos(meta:get_string("transmitter"))

		local player = sender:get_player_name()
		local transmitters = get_transmitters_in_range(pos, player, trans, 8)
		local receivers = {}
		if trans then
			receivers = get_player_receivers(player)
		end

		if fields["transmitter"] then
			if fields.transmitter:match("DCL:") then
				local pinx = tonumber(fields.transmitter:sub(5))
				if pinx and transmitters[pinx] then
					meta:set_string("transmitter", transmitters[pinx].pos)
					minetest.get_node_timer(pos):start(0.2)
					return
				end
			end
		end

		if fields["receiver"] and #receivers > 0 then
			if fields.receiver:match("DCL:") then
				local pinx = tonumber(fields.receiver:sub(5))
				if pinx and receivers[pinx] then
					local meta = minetest.get_meta(trans)

					meta:set_string("target", receivers[pinx].pos)

					minetest.get_node_timer(trans):start(0.2)
					minetest.get_node_timer(pos):start(0.2)
				end
			end
		end
	end,
})
