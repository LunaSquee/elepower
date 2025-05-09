-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epg = ele.external.graphic
local epr = ele.external.ref
local S = ele.translator

-- Formspec helpers

ele.formspec = {}
ele.formspec.version = 6
ele.formspec.gui_switcher_icons = {
    [0] = "elepower_gui_check.png",
    "elepower_gui_cancel.png",
    epg.gui_mesecons_on,
    epg.gui_mesecons_off
}

-- Return the formspec version and size text, along with the inside
-- boundary of the formspec (padded box)
function ele.formspec.begin(width, height, padding)
    padding = padding or 0.375

    local start_x = padding
    local start_y = padding
    local max_x = width - start_x
    local max_y = height - start_y
    local center_x = width / 2 - 0.5

    return "formspec_version[" .. ele.formspec.version .. "]size[" .. width ..
               "," .. height .. "]", start_x, start_y, max_x, max_y, center_x
end

-- Get the absolute width of a list by slot count
-- Distance between slots is 0.25
function ele.formspec.get_list_width(slot_count)
    return ((slot_count - 1) * 0.25) + slot_count
end

-- Move by n steps, leaving a padding of 0.25 in between each step.
-- Minimum steps is 1, 0.5 is half a slot anyways.
-- Similar to get_list_width except that "1" also includes padding for
-- the first slot.
function ele.formspec.move(steps)
    if steps < 1 then return steps end
    return (math.max(steps, 1) * 0.25) + steps
end

-- Get the absolute size (width, height) of a list
function ele.formspec.get_list_size(slots_x, slots_y)
    local in_box_w = ele.formspec.get_list_width(slots_x)
    local in_box_h = ele.formspec.get_list_width(slots_y)

    return in_box_w, in_box_h
end

-- Center a box in another box
-- Return x, y coordinates of the top-left position of the inner box
function ele.formspec.center_in_box(out_box_w, out_box_h, in_box_w, in_box_h)
    local x = out_box_w / 2 - (in_box_w / 2)
    local y = out_box_h / 2 - (in_box_h / 2)
    return x, y
end

-- Center a list within a bounding box
function ele.formspec.center_list_in_box(out_box_w, out_box_h, list_x, list_y)
    local in_box_w, in_box_h = ele.formspec.get_list_size(list_x, list_y)
    local x = out_box_w / 2 - (in_box_w / 2)
    local y = out_box_h / 2 - (in_box_h / 2)
    return x, y, in_box_w, in_box_h
end

-- Generate a grid of x,y positions to add textures to slots
function ele.formspec.slot_grid(start_x, start_y, width, height)
    local rows = {}

    for x = 1, width do
        for y = 1, height do
            if rows[x] == nil then rows[x] = {} end
            rows[x][y] = (start_x + (x - 1) * 0.25 + x) - 1 .. "," ..
                             (start_y + (y - 1) * 0.25 + y) - 1
        end
    end

    return rows
end

function ele.formspec.label(x, y, text)
    text = text or ""
    return "label[" .. x .. "," .. y .. ";" .. text .. "]"
end

function ele.formspec.image(x, y, w, h, image)
    w = w or 1
    h = h or 1
    image = image or ""
    return "image[" .. x .. "," .. y .. ";" .. w .. "," .. h .. ";" .. image ..
               "]"
end

function ele.formspec.textlist(x, y, w, h, name, items)
    w = w or 1
    h = h or 1
    return
        "textlist[" .. x .. "," .. y .. ";" .. w .. "," .. h .. ";" .. name ..
            ";" .. items .. "]"
end

function ele.formspec.field(x, y, w, h, name, label, value)
    w = w or 1
    h = h or 1
    value = value or ""
    return "field[" .. x .. "," .. y .. ";" .. w .. "," .. h .. ";" .. name ..
               ";" .. label .. ";" .. value .. "]"
end

function ele.formspec.checkbox(x, y, name, text, value)
    return "checkbox[" .. x .. "," .. y .. ";" .. name .. ";" .. text .. ";" ..
               (value or "") .. "]"
end

function ele.formspec.button(x, y, w, h, name, text)
    w = w or 1
    h = h or 1
    return "button[" .. x .. "," .. y .. ";" .. w .. "," .. h .. ";" .. name ..
               ";" .. text .. "]"
end

function ele.formspec.tooltip(x, y, w, h, text, bgcolor, fgcolor)
    w = w or 1
    h = h or 1
    text = text or ""
    -- bgcolor and fgcolor are optional
    local color =
        bgcolor ~= nil and (";" .. bgcolor .. ";" .. (fgcolor or "")) or ""
    return "tooltip[" .. x .. "," .. y .. ";" .. w .. "," .. h .. ";" .. text ..
               color .. "]"
end

-- List with game-specifc item slot background
function ele.formspec.list(list_type, name, x, y, w, h)
    return epr.get_itemslot_bg(x, y, w, h) .. "list[" .. list_type .. ";" ..
               name .. ";" .. x .. "," .. y .. ";" .. w .. "," .. h .. ";]"
end

-- Furnace fire graphic
-- Not rotated
function ele.formspec.fuel(x, y, fuel_percent, graphic_bg, graphic_fg)
    graphic_bg = graphic_bg or epg.furnace_fire_bg
    graphic_fg = graphic_fg or epg.furnace_fire_fg
    local lowpart = "^[lowpart:" .. (fuel_percent or 0) .. ":" .. graphic_fg
    local graphic =
        (fuel_percent ~= nil and fuel_percent ~= 0) and graphic_bg .. lowpart or
            graphic_bg
    return "image[" .. x .. "," .. y .. ";1,1;" .. graphic .. "]"
end

-- Progress arrow graphic
-- Rotated
function ele.formspec.progress(x, y, item_percent, graphic_bg, graphic_fg)
    graphic_bg = graphic_bg or epg.gui_furnace_arrow_bg
    graphic_fg = graphic_fg or epg.gui_furnace_arrow_fg
    local lowpart = "^[lowpart:" .. (item_percent or 0) .. ":" .. graphic_fg
    local graphic =
        (item_percent ~= nil and item_percent ~= 0) and graphic_bg .. lowpart or
            graphic_bg
    return
        "image[" .. x .. "," .. y .. ";1,1;" .. graphic .. "^[transformR270" ..
            "]"
end

function ele.formspec.state_switcher(x, y, state)
    if not state then state = 0 end
    local icon = ele.formspec.gui_switcher_icons[state]
    local statedesc = ele.default.states[state]

    if statedesc then
        statedesc = statedesc.d
    else
        statedesc = ""
    end
    statedesc = statedesc .. "\n" .. S("Press to toggle")

    return "image_button[" .. x .. "," .. y .. ";1,1;" .. icon ..
               ";cyclestate;]" .. "tooltip[cyclestate;" .. statedesc .. "]"
end

function ele.formspec.create_bar(x, y, metric, color, small)
    if not metric or type(metric) ~= "number" or metric < 0 then metric = 0 end

    local width = 1
    local gauge = ele.formspec.image(x, y, 1, 2.8, "elepower_gui_gauge.png")

    -- Smaller width bar
    if small then
        width = 0.25
        gauge = ""
    end

    return ele.formspec.image(x, y, width, 2.8,
                              "elepower_gui_barbg.png" .. "\\^[lowpart\\:" ..
                                  metric ..
                                  "\\:elepower_gui_bar.png\\\\^[multiply\\\\:" ..
                                  color) .. gauge
end

function ele.formspec.power_meter(capacitor)
    if not capacitor then
        capacitor = {capacity = 8000, storage = 0, usage = 0}
    end

    local pw_percent = math.floor(100 * capacitor.storage / capacitor.capacity)
    local usage = capacitor.usage
    if not usage then usage = 0 end

    local tooltip = core.colorize("#c60303", S("Energy Storage") .. "\n") ..
                        core.colorize("#0399c6", ele.capacity_text(
                                          capacitor.capacity, capacitor.storage)) ..
                        core.colorize("#565656",
                                      "\n" .. S("Power Used / Generated") ..
                                          ": " .. usage .. " " .. ele.unit)

    return ele.formspec.create_bar(0.375, 0.375, pw_percent, "#00a1ff") ..
               ele.formspec
                   .image(0.625, 3.25, 0.5, 0.5,
                          "elepower_gui_icon_power_stored.png") ..
               ele.formspec.tooltip(0.375, 0.375, 1, 2.8, tooltip)
end

-- Fluid bar for formspec
function ele.formspec.fluid_bar(x, y, fluid_buffer)
    local texture = epg.water
    local metric = 0
    local tooltip = ele.formspec.tooltip(x, y, 1, 2.8, S("Empty Buffer"))

    if fluid_buffer and fluid_buffer.fluid and fluid_buffer.fluid ~= "" and
        core.registered_nodes[fluid_buffer.fluid] ~= nil then
        texture = core.registered_nodes[fluid_buffer.fluid].tiles[1]
        if type(texture) == "table" then texture = texture.name end

        local fdesc = fluid_lib.cleanse_node_description(fluid_buffer.fluid)
        local text = ("%s\n%s / %s %s"):format(fdesc, ele.helpers
                                                   .comma_value(
                                                   fluid_buffer.amount),
                                               ele.helpers
                                                   .comma_value(
                                                   fluid_buffer.capacity),
                                               fluid_lib.unit)

        metric = math.floor(100 * fluid_buffer.amount / fluid_buffer.capacity)
        tooltip = ele.formspec.tooltip(x, y, 1, 2.8, text)
    end

    return ele.formspec.image(x, y, 1, 2.8,
                              "elepower_gui_barbg.png" .. "\\^[lowpart\\:" ..
                                  metric .. "\\:" .. texture ..
                                  "\\\\^[resize\\\\:64x128") ..
               ele.formspec.image(x, y, 1, 2.8, "elepower_gui_gauge.png") ..
               tooltip
end
