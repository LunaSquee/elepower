local S = ele.translator

local list_def = {
	{material = "bronze",     description = S("Bronze"),     color = "#fa7b26", dust = true, plate = true, gear = true},
	{material = "copper",     description = S("Copper"),     color = "#fcb15f", dust = true, plate = true, gear = true},
	{material = "brass",      description = S("Brass"),      color = "#cdaf2c", dust = true, plate = true, gear = true},
	{material = "gold",       description = S("Gold"),       color = "#ffff47", dust = true, plate = true, gear = true},
	{material = "steel",      description = S("Steel"),      color = "#ffffff", dust = true, plate = true, gear = true},
	{material = "tin",        description = S("Tin"),        color = "#c1c1c1", dust = true, plate = true, gear = true},
	{material = "silver",     description = S("Silver"),     color = "#d7e2e8", dust = true, plate = true, gear = true},
	{material = "lead",       description = S("Lead"),       color = "#374559", dust = true, plate = true, gear = true},
	{material = "iron",       description = S("Iron"),       color = "#dddddd", dust = true, plate = true, gear = true},
	{material = "diamond",    description = S("Diamond"),    color = "#02c1e8", dust = true, plate = true, gear = true},
	{material = "nickel",     description = S("Nickel"),     color = "#d6d5ab", dust = true, plate = true, gear = true},
	{material = "invar",      description = S("Invar"),      color = "#71848c", dust = true, plate = true, gear = true},
	{material = "electrum",   description = S("Electrum"),   color = "#ebeb90", dust = true, plate = true, gear = true},
	{material = "viridisium", description = S("Viridisium"), color = "#5b9751", dust = true, plate = true, gear = true},
	{material = "zinc",       description = S("Zinc"),       color = "#598a9e", dust = true, plate = true},
	{material = "coal",       description = S("Coal"),       color = "#1f1f1f", dust = true},
	{material = "mese",       description = S("Mese"),       color = "#fdff2d99", dust = true},
	{material = "wood",       description = S("Wood"),       color = "#847454", dust = S("Sawdust"), gear = true}
}

elepd.registered_gears = {}
elepd.registered_dusts = {}
elepd.registered_plates = {}

function elepd.register_plate(mat, data)
	local mod      = minetest.get_current_modname()
	local itemname = mod..":"..mat.."_plate"

	data.item = itemname
	elepd.registered_plates[mat] = data

	-- Make descriptions overridable
	local description = data.description .. " " ..S("Plate")
	if data.force_description then
		description = data.description
	end

	minetest.register_craftitem(itemname, {
		description     = description,
		inventory_image = "elepower_plate.png^[multiply:" .. data.color,
		groups          = {
			["plate_" .. mat] = 1,
			plate = 1
		}
	})
end

function elepd.register_dust(mat, data)
	local mod      = minetest.get_current_modname()
	local itemname = mod..":"..mat.."_dust"
	local image = "elepower_dust.png^[multiply:" .. data.color

	if mat == "mese" then
		image = "elepower_dust.png^[colorize:" .. data.color.."^[multiply:" .. data.color
	end

	data.item = itemname
	elepd.registered_dusts[mat] = data

	-- Make descriptions overridable
	local description = S("Pulverized").. " " .. data.description
	if data.force_description then
		description = data.description
	end

	minetest.register_craftitem(itemname, {
		description     = description,
		inventory_image = image,
		groups          = {
			["dust_" .. mat] = 1,
			dust = 1
		}
	})
end

function elepd.register_gear(mat, data)
	local mod      = minetest.get_current_modname()
	local itemname = mod..":"..mat.."_gear"

	data.item = itemname
	elepd.registered_gears[mat] = data

	-- Make descriptions overridable
	local description = data.description .. " " .. S("Gear")
	if data.force_description then
		description = data.description
	end

	minetest.register_craftitem(itemname, {
		description     = description,
		inventory_image = "elepower_gear.png^[multiply:" .. data.color,
		groups          = {
			["gear_" .. mat] = 1,
			gear = 1
		}
	})
end

------------------
-- Register all --
------------------

for _,spec in pairs(list_def) do
	local desc  = spec.description
	local name  = spec.material
	local color = spec.color

	if spec.dust ~= nil and spec.dust ~= false then
		local fdesc = nil
		if spec.dust ~= true then
			fdesc = spec.dust
		end

		elepd.register_dust(name, {
			description       = fdesc or desc,
			color             = color,
			force_description = fdesc ~= nil,
		})
	end

	if spec.gear ~= nil and spec.gear ~= false then
		local fdesc = nil
		if spec.gear ~= true then
			fdesc = spec.gear
		end

		elepd.register_gear(name, {
			description       = fdesc or desc,
			color             = color,
			force_description = fdesc ~= nil,
		})
	end

	if spec.plate ~= nil and spec.plate ~= false then
		local fdesc = nil
		if spec.plate ~= true then
			fdesc = spec.plate
		end

		elepd.register_plate(name, {
			description       = fdesc or desc,
			color             = color,
			force_description = fdesc ~= nil,
		})
	end
end
