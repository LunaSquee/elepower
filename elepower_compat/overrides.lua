-- Override external resources by minetest.conf
local cset = core.settings
local prefix = "elepower_resource_"

-- Booleans

if cset:has(prefix .. "enable_iron_tools") then
    ele.external.tools.enable_iron_tools =
        cset:get_bool(prefix .. "enable_iron_tools")
end

if cset:has(prefix .. "enable_lead_tools") then
    ele.external.tools.enable_lead_tools =
        cset:get_bool(prefix .. "enable_lead_tools")
end

if cset:has(prefix .. "enable_iron_armor") then
    ele.external.tools.enable_iron_armor =
        cset:get_bool(prefix .. "enable_iron_armor")
end

if cset:has(prefix .. "enable_carbon_fiber_armor") then
    ele.external.tools.enable_carbon_fiber_armor =
        cset:get_bool(prefix .. "enable_carbon_fiber_armor")
end

if cset:has(prefix .. "conduit_dirt_with_grass") then
    ele.external.conduit_dirt_with_grass =
        cset:get_bool(prefix .. "conduit_dirt_with_grass")
end

if cset:has(prefix .. "conduit_dirt_with_dry_grass") then
    ele.external.conduit_dirt_with_dry_grass =
        cset:get_bool(prefix .. "conduit_dirt_with_dry_grass")
end

if cset:has(prefix .. "conduit_stone_block") then
    ele.external.conduit_stone_block = cset:get_bool(prefix ..
                                                         "conduit_stone_block")
end

if cset:has(prefix .. "conduit_stone_block_desert") then
    ele.external.conduit_stone_block_desert =
        cset:get_bool(prefix .. "conduit_stone_block_desert")
end

if cset:has(prefix .. "player_inv_width") then
    ele.external.player_inv_width = tonumber(cset:get(prefix ..
                                                          "player_inv_width"))
end

-- Custom item slot background

if cset:has(prefix .. "itemslot_bg") then
    local image = cset:get(prefix .. "itemslot_bg")
    ele.external.ref.get_itemslot_bg = function(x, y, w, h)
        local str = ""
        for ix = 1, w do
            for iy = 1, h do
                str = str .. "image[" .. (x + ((ix - 1) * 0.25)) .. "," ..
                          (y + ((iy - 1) * 0.25)) .. ";1,1;" .. image .. "]"
            end
        end
        return str
    end
end

-- Sounds

for sound in pairs(ele.external.sounds) do
    local key = prefix .. "sound_" .. sound
    if cset:has(key) then ele.external.sounds[key] = cset:get(key) end
end

-- Ingredients

for ing in pairs(ele.external.ing) do
    local key = prefix .. ing
    if cset:has(key) then ele.external.ing[key] = cset:get(key) end
end

-- Graphics

for graphic in pairs(ele.external.graphic) do
    local key = prefix .. "graphic_" .. graphic
    if cset:has(key) then ele.external.graphic[key] = cset:get(key) end
end
