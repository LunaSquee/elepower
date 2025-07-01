-- see elepower_compat >> external.lua for explanation
-- shorten table ref
local epr = ele.external.ref
local efs = ele.formspec
local S = ele.translator

local function get_formspec(mode, buffer, state)
    local start, bx, by, mx = efs.begin(11.75, 10.45)
    local btn_x = mx - 4.25
    local rot = "^\\[transformR90"

    if not mode then mode = 0 end
    if mode == 1 then rot = "^\\[transformR270" end

    return start .. efs.state_switcher(bx, by, state) ..
               efs.fluid_bar(mx - 1, 1, buffer) ..
               efs.list("context", "src", 4, 1, 1, 1) ..
               efs.list("context", "dst", 4, 2.25, 1, 1) .. "image_button[" ..
               btn_x .. ",1;1,1;gui_furnace_arrow_bg.png" .. rot .. ";flip;]" ..
               "tooltip[flip;" .. S("Toggle Extract/Insert") .. "]" ..
               epr.gui_player_inv() .. "listring[current_player;main]" ..
               "listring[context;src]" .. "listring[current_player;main]" ..
               "listring[context;dst]" .. "listring[current_player;main]"
end

local function on_timer(pos, elapsed)
    local refresh = false
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local buffer = fluid_lib.get_buffer_data(pos, "input")
    local mode = meta:get_int("mode")
    local state = meta:get_int("state")

    local is_enabled = ele.helpers.state_enabled(meta, pos, state)

    local bucket_slot = inv:get_stack("src", 1)
    local bucket_name = bucket_slot:get_name()

    if is_enabled then
        local liquid_list = fluid_lib.get_liquid_list()
        if mode == 0 and
            (bucket_name == fluid_lib.get_empty_bucket() or bucket_name ==
                "elepower_dynamics:gas_container") and buffer.amount >= 1000 then
            -- Fill bucket
            local bitem
            if minetest.get_item_group(buffer.fluid, "gas") > 0 then
                bitem = ele.gases[buffer.fluid]
                if bucket_name ~= "elepower_dynamics:gas_container" then
                    bitem = nil
                end
            else
                bitem = liquid_list[buffer.fluid]
                if bucket_name ~= fluid_lib.get_empty_bucket() then
                    bitem = nil
                end
            end

            if bitem then
                local bucket_item =
                    fluid_lib.get_bucket_for_source(buffer.fluid) or
                        bitem.itemname
                if bucket_item then
                    local bstack = ItemStack(bucket_item)
                    if inv:room_for_item("dst", bstack) then
                        inv:add_item("dst", bstack)
                        buffer.amount = buffer.amount - 1000

                        bucket_slot:take_item()
                        inv:set_stack("src", 1, bucket_slot)

                        refresh = true
                    end
                end
            end
        elseif mode == 1 and (fluid_lib.get_source_for_bucket(bucket_name) or
            ele.get_gas_for_container(bucket_name)) then
            -- Empty bucket
            local fluid
            local gas = false

            if minetest.get_item_group(bucket_name, "gas_container") > 0 then
                gas = true
                fluid = ele.get_gas_for_container(bucket_name)
            else
                fluid = fluid_lib.get_source_for_bucket(bucket_name)
            end

            if buffer.fluid == fluid or buffer.fluid == "" then
                local bitem = ItemStack(fluid_lib.get_empty_bucket())
                if gas then
                    bitem = ItemStack("elepower_dynamics:gas_container")
                end

                if inv:room_for_item("dst", bitem) and buffer.amount + 1000 <=
                    buffer.capacity then
                    buffer.amount = buffer.amount + 1000
                    buffer.fluid = fluid
                    inv:add_item("dst", bitem)

                    bucket_slot:take_item()
                    inv:set_stack("src", 1, bucket_slot)

                    refresh = true
                end
            end
        end
    end

    if buffer.amount <= 0 then
        buffer.amount = 0
        buffer.fluid = ""
    end

    meta:set_int("input_fluid_storage", buffer.amount)
    meta:set_string("input_fluid", buffer.fluid)
    meta:set_string("formspec", get_formspec(mode, buffer, state))

    return refresh
end

local function get_fields(pos, formname, fields, sender)
    if sender and sender ~= "" and
        minetest.is_protected(pos, sender:get_player_name()) then return end

    if fields["quit"] then return end
    local meta = minetest.get_meta(pos)

    if fields["flip"] then
        local fint = meta:get_int("mode")
        if fint == 0 then
            fint = 1
        else
            fint = 0
        end
        meta:set_int("mode", fint)
    end

    ele.helpers.start_timer(pos)
end

ele.register_base_device("elepower_machines:bucketer", {
    description = S("Bucketer"),
    groups = {
        oddly_breakable_by_hand = 1,
        cracky = 3,
        pickaxey = 1,
        fluid_container = 1,
        tubedevice = 1,
        tubedevice_receiver = 1
    },
    fluid_buffers = {input = {capacity = 8000, accepts = true}},
    paramtype2 = "facedir",
    on_timer = on_timer,
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("src", 1)
        inv:set_size("dst", 1)

        meta:set_string("formspec", get_formspec())
    end,
    tiles = {
        "elepower_machine_top.png", "elepower_machine_base.png",
        "elepower_machine_side.png", "elepower_machine_side.png",
        "elepower_machine_side.png",
        "elepower_machine_side.png^elepower_bucketer.png"
    },
    on_receive_fields = get_fields,

    allow_metadata_inventory_put = ele.default.allow_metadata_inventory_put,
    allow_metadata_inventory_move = ele.default.allow_metadata_inventory_move,
    allow_metadata_inventory_take = ele.default.allow_metadata_inventory_take,

    on_metadata_inventory_move = ele.default.metadata_inventory_changed,
    on_metadata_inventory_put = ele.default.metadata_inventory_changed,
    on_metadata_inventory_take = ele.default.metadata_inventory_changed
})
