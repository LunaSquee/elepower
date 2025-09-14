-- This file will only be loaded if elepower PAPI is used WITHOUT elepower.
-- This shall be kept in sync with elepower_compat from elepower.
ele.external = {}
ele.external.graphic = {}
ele.external.ref = {}
ele.external.sounds = {}

ele.external.ref.player_inv_width = 8
ele.external.ref.get_itemslot_bg = function() return "" end
ele.external.ref.gui_player_inv = function(center_on, y)
    local width = ele.external.ref.player_inv_width
    y = y or 5
    center_on = center_on or 11.75
    local x = center_on / 2 - (((width - 1) * 0.25) + width) / 2
    return ele.external.ref.get_itemslot_bg(x, y, width, 1) ..
               "list[current_player;main;" .. x .. "," .. y .. ";" .. width ..
               ",1;]" ..
               ele.external.ref.get_itemslot_bg(x, y + 1.375, width, 3) ..
               "list[current_player;main;" .. x .. "," .. (y + 1.375) .. ";" ..
               width .. ",3;" .. width .. "]"
end

ele.external.graphic.water = "default_water.png"
ele.external.graphic.furnace_fire_bg = "default_furnace_fire_bg.png"
ele.external.graphic.furnace_fire_fg = "default_furnace_fire_fg.png"
ele.external.graphic.gui_furnace_arrow_bg = "gui_furnace_arrow_bg.png"
ele.external.graphic.gui_furnace_arrow_fg = "gui_furnace_arrow_fg.png"
ele.external.graphic.gui_mesecons_on =
    "mesecons_wire_on.png^elepower_gui_mese_mask.png^\\[makealpha\\:255,0,0"
ele.external.graphic.gui_mesecons_off =
    "mesecons_wire_off.png^elepower_gui_mese_mask.png^\\[makealpha\\:255,0,0"

if minetest.get_modpath("default") ~= nil then
    ele.external.sounds.node_sound_water = default.node_sound_water_defaults()
end

if minetest.get_modpath("mcl_core") ~= nil then
    ele.external.sounds.node_sound_water =
        mcl_sounds.node_sound_water_defaults()
    ele.external.ref.get_itemslot_bg = mcl_formspec.get_itemslot_bg_v4
    ele.external.ref.player_inv_width = 9
    ele.external.ref.gui_player_inv = function(center_on, y)
        y = y or 5
        center_on = center_on or 11.75
        local x = center_on / 2 - ((8 * 0.25) + 9) / 2
        return mcl_formspec.get_itemslot_bg_v4(x, y, 9, 3) ..
                   "list[current_player;main;" .. x .. "," .. y .. ";9,3;9]" ..
                   mcl_formspec.get_itemslot_bg_v4(x, y + 4, 9, 1) ..
                   "list[current_player;main;" .. x .. "," .. (y + 4) ..
                   ";9,1;]"
    end
    ele.external.graphic.water = "mcl_core_water_source_animation.png"
    ele.external.graphic.gui_mesecons_on =
        "mesecons_wire_on.png^elepower_gui_mese_mask.png^\\[makealpha\\:255,0,0"
    ele.external.graphic.gui_mesecons_off =
        "mesecons_wire_off.png^elepower_gui_mese_mask.png^\\[makealpha\\:255,0,0"
    ele.external.graphic.furnace_fire_bg = "default_furnace_fire_bg.png"
    ele.external.graphic.furnace_fire_fg = "default_furnace_fire_fg.png"
    ele.external.graphic.gui_furnace_arrow_bg = "gui_furnace_arrow_bg.png"
    ele.external.graphic.gui_furnace_arrow_fg = "gui_furnace_arrow_fg.png"
end
