# Elepower Power API

This is the power transfer API for Elepower. It can be used outside of Elepower with other mods.

## How to use

### 1. Apply the following groups:

* `ele_machine` - Any machine that does something with power. Combine with the following:
  * `ele_provider` - Any machine that can provide power (generator, storage, etc).
  * `ele_user` - Any machine that uses power.
  * `ele_storage` - Any machine that stores power.
* `ele_conductor` - A node that is used to connect `ele_machine` nodes together.

### 2. Set constants in your node definition:

* `ele_capacity = 12000`
  * Static capacitor for nodes. Shows how much power this machine can store by itself.
  * Can be overridden by metadata: `capacity`

* `ele_inrush = 32`
  * Decides how much power can be inserted into this machine's internal capacitor.
  * Can be overridden by metadata: `inrush`

* `ele_output = 64`
  * Decides how much power a `ele_provider` node can output.

* `ele_usage = 16`
  * How much power this machine uses or generates.
  * Can be overridden by metadata: `usage`

* `ele_active_node = nil`
  * Set to true or a string to also register an active variant of this node.
  * If the parameter is a boolean, `_active` will be appended to the `nodename`.

* `ele_active_nodedef = nil`
  * If set, the `ele_active_node` will have this table in its nodedef.
  * Intended use is to set different textures or light output.

### 3. Register your node

Use `ele.register_machine(nodename, nodedef)` or `ele.register_base_device(nodename, nodedef)` to register your node to make it work correctly with the power network. More details provided below.

## API

* `ele.register_base_device(nodename, nodedef)` - Register a base device. Depending on the groups provided, it will assign some sane defaults for various APIs such as pipeworks, mesecons, tubelib and node_io.
  * Preserves elepower node metadata on break automatically.
  * Using the `tubedevice`/`tube` group registers item-related callbacks. The input inventory is assumed to be `src` and the output `dst`.
  * If `fluid_lib` is installed and `fluid_container` group is provided, the node is automatically registered as a fluid-containing node with `fluid_lib`.

* `ele.register_machine(nodename, nodedef)` - Register a powered machine. Calls `register_base_device` and applies the following defaults:
  * ```lua
    ele_capacity = 1600,
    ele_inrush = 64,
    ele_usage = 64,
    ele_output = 64,
    ele_sides = nil
    ```
* `ele.register_conduit(nodename, nodedef)` - Register a conduit with a generated nodebox. `ele_conductor_density` controls the thickness of the conduit, default is `1 / 8`.

* `ele.register_tool(itemname, nodedef)` - Register a powered tool. Works like a regular Luanti tool, except the durability is the energy meter and it does not break when depleted. Defaults:
  * ```lua
    ele_capacity = 1600,
    ele_usage    = 64,
    ```

The rest of the provided functions are used by elepower internally, but may prove useful in your mod as well.

* `ele.clear_networks(pos)` - If not using elepower's device registration functions, use this to update neighboring power networks on construct or destruct.
* `ele.helpers.register_liquid(liquid, def)` - Helper for registering liquids.
* `ele.helpers.round(v)` - Round a number instead of flooring it.
* `ele.helpers.swap_node(pos, noded)` - Smarter node swapper for machines.
* `ele.helpers.get_or_load_node(pos)` - Get or load a node.
* `ele.helpers.get_item_group(name, grp)` - Returns boolean if item has group.
* `ele.helpers.start_timer(pos)` - Starts a 1 second timer if one has not been started before.
* `ele.helpers.flatten(map)` - Flatten a table of tables.
* `ele.helpers.node_compare(pos, name)` - Check if a node is the same as the provided name. Also works for groups.
* `ele.helpers.get_node_property(meta, pos, prop)` - Get an elepower definition property or its meta override.
* `ele.helpers.get_first_line(str)` - Get the first line of a string.
* `ele.helpers.scan_item_list(mat, keyword)` - Find items by material and keyword.
* `ele.helpers.face_front(pos, fd)` - Get the node position in front of your node.
* `ele.helpers.comma_value(n)` - Add commas to thousands. (Example: 1000 -> 1,000).
* `ele.helpers.state_enabled(meta, pos, state)` - Get is device enabled.
* `ele.helpers.merge_tables(t1, t2)` - Recursive table merge.
* `ele.formspec.state_switcher(x, y, state)` - Render machine state switcher formspec.
* `ele.formspec.power_meter(capacitor)` - Render the power buffer. `capacitor` is a table of `capacity`, `storage` and `usage`.
* `ele.formspec.fluid_bar(x, y, fluid_buffer)` - Render a fluid bar.
* `ele.formspec.create_bar(x, y, metric, color, small)` - Render a bar.
* `ele.formspec.fuel(x, y, fuel_percent, graphic_bg, graphic_fg)`
* `ele.formspec.progress(x, y, item_percent, graphic_bg, graphic_fg)`
* `ele.formspec.begin(width, height, padding)`
* `ele.formspec.get_list_width(slot_count)`
* `ele.formspec.move(steps)`
* `ele.formspec.get_list_size(slots_x, slots_y)`
* `ele.formspec.center_in_box(out_box_w, out_box_h, in_box_w, in_box_h)`
* `ele.formspec.center_list_in_box(out_box_w, out_box_h, list_x, list_y)`
* `ele.formspec.slot_grid(start_x, start_y, width, height)`
* `ele.formspec.label(x, y, text)`
* `ele.formspec.image(x, y, w, h, image)`
* `ele.formspec.textlist(x, y, w, h, name, items)`
* `ele.formspec.field(x, y, w, h, name, label, value)`
* `ele.formspec.checkbox(x, y, name, text, value)`
* `ele.formspec.button(x, y, w, h, name, text)`
* `ele.formspec.tooltip(x, y, w, h, text, bgcolor, fgcolor)`
* `ele.formspec.list(list_type, name, x, y, w, h)`
