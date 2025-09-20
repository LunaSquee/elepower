------------------------------------------------------------
--              ___ _                                     --
--             | __| |___ _ __  _____ __ _____ _ _        --
--             | _|| / -_) '_ \/ _ \ V  V / -_) '_|       --
--             |___|_\___| .__/\___/\_/\_/\___|_|         --
--              ___     _|_|                  _           --
--             | __|_ _| |_ ___ _ _ _ _  __ _| |          --
--             | _|\ \ /  _/ -_) '_| ' \/ _` | |          --
--             |___/_\_\\__\___|_| |_||_\__,_|_|          --
------------------------------------------------------------
--    These are all the nodes and items used by elepower  --
--       which are not contained in this mod. These       --
--     names/references can be updated to more easily     --
--     integrate elepower with non-minetest game, game.   --
------------------------------------------------------------
------------
-- Tables --
------------
ele:put_in_new("external", {})
ele.put_in_new(ele.external, "ref", {})
ele.put_in_new(ele.external, "ing", {})
ele.put_in_new(ele.external, "tools", {})
ele.put_in_new(ele.external, "armor", {})
ele.put_in_new(ele.external, "sounds", {})
ele.put_in_new(ele.external, "graphic", {})

-----------
-- Index --
-----------
--- settings to update............line 44
--- elepower_papi.................line 205
--- elepower_dynamics.............line 226
--- elepower_machines.............line 350
--- elepower_tools................line 560
--- elepower_farming..............line 605
--- elepower_solar................line 697
--- elepower_thermal..............line 730
--- elepower_mining...............line 761
--- elepower_nuclear..............line 785
--- elepower_wireless.............line 856
--- elepower_lighting.............line 915
--- elepower_tome.................line 972

------------------------------------------------------------
--         _   _ _   ___      _   _   _                   --
--        /_\ | | | / __| ___| |_| |_(_)_ _  __ _ ___     --
--       / _ \| | | \__ \/ -_)  _|  _| | ' \/ _` (_-<     --
--      /_/ \_\_|_| |___/\___|\__|\__|_|_||_\__, /__/     --
--                                          |___/         --
------------------------------------------------------------
--     Update these refs to new values/names to remove    --
--               elepower reliance on default             --
------------------------------------------------------------
-------------
-- General --
-------------

-- All of these can be configured with setting "elepower_resource_" + last table key
-- e.g. elepower_resource_enable_iron_tools = false
ele.put_in_new(ele.external.tools, "enable_iron_tools",         true)
ele.put_in_new(ele.external.tools, "enable_lead_tools",         true)
ele.put_in_new(ele.external.armor, "enable_iron_armor",         false)
ele.put_in_new(ele.external.armor, "enable_carbon_fiber_armor", false)

ele.put_in_new(ele.external, "conduit_dirt_with_grass",     false)
ele.put_in_new(ele.external, "conduit_dirt_with_dry_grass", false)
ele.put_in_new(ele.external, "conduit_stone_block",         false)
ele.put_in_new(ele.external, "conduit_stone_block_desert",  false)

----------------
-- References --
----------------
ele.put_in_new(ele.external.ref, "player_inv_width", 8)

-- Item slot background can be configured with setting "elepower_resource_itemslot_bg"
ele.put_in_new(ele.external.ref, "get_itemslot_bg", function() return "" end)
ele.put_in_new(ele.external.ref, "gui_player_inv", function(center_on, y)
	local width = ele.external.ref.player_inv_width
	y = y or 5
	center_on = center_on or 11.75
	local x = center_on / 2 - (((width - 1) * 0.25) + width) / 2
	return ele.external.ref.get_itemslot_bg(x, y, width, 1) ..
		   "list[current_player;main;"..x..","..y..";"..width..",1;]" ..
		   ele.external.ref.get_itemslot_bg(x, y + 1.375, width, 3) ..
		   "list[current_player;main;"..x..","..(y + 1.375)..";"..width..",3;"..width.."]"
end)

-------------------------------------------------
-- Ingredients or node item references in code --
-------------------------------------------------

-- All of the ingredients can be configured with setting "elepower_resource_" + last table key
-- e.g. elepower_resource_group_stick = group:sticks
ele.put_in_new(ele.external.ing, "group_stick",        "group:stick")
ele.put_in_new(ele.external.ing, "group_stone",        "group:stone")
ele.put_in_new(ele.external.ing, "group_color_red",    "group:color_red")
ele.put_in_new(ele.external.ing, "group_color_green",  "group:color_green")
ele.put_in_new(ele.external.ing, "group_color_blue",   "group:color_blue")
ele.put_in_new(ele.external.ing, "group_color_black",  "group:color_black")
ele.put_in_new(ele.external.ing, "group_color_violet", "group:color_violet")
ele.put_in_new(ele.external.ing, "group_wood",         "group:wood")

ele.put_in_new(ele.external.ing, "water_source",            "")
ele.put_in_new(ele.external.ing, "stone",                   "")
ele.put_in_new(ele.external.ing, "dirt",                    "") -- only used by conduit_dirt_with_grass/dry_grass
ele.put_in_new(ele.external.ing, "wheat",                   "") -- only used by conduit_dirt_with_dry_grass
ele.put_in_new(ele.external.ing, "glass",                   "")
ele.put_in_new(ele.external.ing, "seed_wheat",              "") -- essential to acidic compound
ele.put_in_new(ele.external.ing, "iron_lump",               "") -- optional, will be registered by elepower_dynamic
ele.put_in_new(ele.external.ing, "coal_lump",               "")
ele.put_in_new(ele.external.ing, "copper_ingot",            "")
ele.put_in_new(ele.external.ing, "silver_ingot",            "") -- optional, will be registered by elepower_compat
ele.put_in_new(ele.external.ing, "gold_ingot",              "")
ele.put_in_new(ele.external.ing, "tin_ingot",               "") -- optional, will be registered by elepower_compat
ele.put_in_new(ele.external.ing, "bronze_ingot",            "") -- optional, will be registered by elepower_compat
ele.put_in_new(ele.external.ing, "iron_ingot",              "") -- optional, will be registered by elepower_dynamic
ele.put_in_new(ele.external.ing, "iron_block",              "") -- optional, will be registered by elepower_dynamic
ele.put_in_new(ele.external.ing, "steel_ingot",             "") -- optional, will be registered by elepower_dynamic
ele.put_in_new(ele.external.ing, "steel_block",             "") -- optional, will be registered by elepower_dynamic
ele.put_in_new(ele.external.ing, "diamond_block",           "")
ele.put_in_new(ele.external.ing, "mese",                    "")
ele.put_in_new(ele.external.ing, "mese_crystal",            "")
ele.put_in_new(ele.external.ing, "mese_crystal_fragment",   "") -- may be equal to mese_crystal if there is no distinct item
ele.put_in_new(ele.external.ing, "mese_lamp",               "")
ele.put_in_new(ele.external.ing, "flour",                   "")
ele.put_in_new(ele.external.ing, "sand",                    "")
ele.put_in_new(ele.external.ing, "desert_sand",             "")
ele.put_in_new(ele.external.ing, "cobble",                  "")
ele.put_in_new(ele.external.ing, "gravel",                  "")
ele.put_in_new(ele.external.ing, "brick",                   "")
ele.put_in_new(ele.external.ing, "flint",                   "")
ele.put_in_new(ele.external.ing, "clay_brick",              "")
ele.put_in_new(ele.external.ing, "obsidian",                "")
ele.put_in_new(ele.external.ing, "lava_source",             "")
ele.put_in_new(ele.external.ing, "hoe_steel",               "")
ele.put_in_new(ele.external.ing, "axe_steel",               "")
ele.put_in_new(ele.external.ing, "tree",                    "")
ele.put_in_new(ele.external.ing, "leaves",                  "")
ele.put_in_new(ele.external.ing, "apple",                   "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "jungle_tree",             "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "jungle_leaves",           "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "pine_tree",               "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "pine_needles",            "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "acacia_tree",             "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "acacia_leaves",           "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "aspen_tree",              "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "aspen_leaves",            "") -- used by treecutter, needs better solution
ele.put_in_new(ele.external.ing, "slab_wood",               "")
ele.put_in_new(ele.external.ing, "stick",                   "")
ele.put_in_new(ele.external.ing, "paper",                   "") -- elepower_lighting decorative shades only
ele.put_in_new(ele.external.ing, "farming_soil",            "")
ele.put_in_new(ele.external.ing, "farming_soil_wet",        "")
ele.put_in_new(ele.external.ing, "slab_glass",              "")
ele.put_in_new(ele.external.ing, "dye_red",                 "")
ele.put_in_new(ele.external.ing, "dye_green",               "")
ele.put_in_new(ele.external.ing, "dye_blue",                "")
ele.put_in_new(ele.external.ing, "furnace",                 "")
ele.put_in_new(ele.external.ing, "obsidian_glass",          "")
ele.put_in_new(ele.external.ing, "slab_stone_block",        "") -- only used by conduit_stone_block
ele.put_in_new(ele.external.ing, "blueberry_bush_leaves",   "") -- tome only, could be any leaves
ele.put_in_new(ele.external.ing, "slab_desert_stone_block", "") -- only used by conduit_stone_block_desert

------------
-- Sounds --
------------

-- All of these can be configured with setting "elepower_resource_sound_" + last table key
-- e.g. elepower_resource_sound_tool_breaks = default_tool_breaks
ele.put_in_new(ele.external.sounds, "node_sound_stone",  {})
ele.put_in_new(ele.external.sounds, "node_sound_water",  {})
ele.put_in_new(ele.external.sounds, "node_sound_wood",   {})
ele.put_in_new(ele.external.sounds, "node_sound_glass",  {})
ele.put_in_new(ele.external.sounds, "node_sound_metal",  {})
ele.put_in_new(ele.external.sounds, "tool_breaks",       {})
ele.put_in_new(ele.external.sounds, "dig_crumbly",       {})
ele.put_in_new(ele.external.sounds, "node_sound_dirt_c", {})

---------------------
-- Graphics/Images --
---------------------

-- All of these can be configured with setting "elepower_resource_graphic_" + last table key
-- e.g. elepower_resource_graphic_water = default_water.png
ele.put_in_new(ele.external.graphic, "water",                "")
ele.put_in_new(ele.external.graphic, "grass",                "")
ele.put_in_new(ele.external.graphic, "dirt",                 "")
ele.put_in_new(ele.external.graphic, "grass_side",           "")
ele.put_in_new(ele.external.graphic, "grass_dry",            "")
ele.put_in_new(ele.external.graphic, "grass_side_dry",       "")
ele.put_in_new(ele.external.graphic, "stone_block",          "")
ele.put_in_new(ele.external.graphic, "desert_stone_block",   "")
ele.put_in_new(ele.external.graphic, "stone",                "")
ele.put_in_new(ele.external.graphic, "wood",                 "")
ele.put_in_new(ele.external.graphic, "obsidian_glass",       "")
ele.put_in_new(ele.external.graphic, "furnace_fire_bg",      "")
ele.put_in_new(ele.external.graphic, "furnace_fire_fg",      "")
ele.put_in_new(ele.external.graphic, "gui_furnace_arrow_bg", "")
ele.put_in_new(ele.external.graphic, "gui_furnace_arrow_fg", "")
ele.put_in_new(ele.external.graphic, "gui_mesecons_on",      "")
ele.put_in_new(ele.external.graphic, "gui_mesecons_off",     "")
ele.put_in_new(ele.external.graphic, "farming_wheat",        "")
ele.put_in_new(ele.external.graphic, "farming_wheat_seed",   "")

------------------------------------------------------------
--  ___ _                                ___           _  --
-- | __| |___ _ __  _____ __ _____ _ _  | _ \__ _ _ __(_) --
-- | _|| / -_) '_ \/ _ \ V  V / -_) '_| |  _/ _` | '_ \ | --
-- |___|_\___| .__/\___/\_/\_/\___|_|   |_| \__,_| .__/_| --
--           |_|                                 |_|      --
------------------------------------------------------------
--     Other mods nodes/items used by elepower_papi       --
------------------------------------------------------------
------------------
-- formspec.lua --
------------------
-- uses graphic.water

-----------------
-- helpers.lua --
-----------------
-- uses sounds.node_sound_water

-- rest NIL

------------------------------------------------------------
--            ___ _                                       --
--           | __| |___ _ __  _____ __ _____ _ _          --
--           | _|| / -_) '_ \/ _ \ V  V / -_) '_|         --
--           |___|_\___| .__/\___/\_/\_/\___|_|           --
--            ___      |_|              _                 --
--           |   \ _  _ _ _  __ _ _ __ (_)__ ___          --
--           | |) | || | ' \/ _` | '  \| / _(_-<          --
--           |___/ \_, |_||_\__,_|_|_|_|_\__/__/          --
--                 |__/                                   --
------------------------------------------------------------
--   Other mods nodes/items used by elepower_dynamics     --
------------------------------------------------------------
--------------------
-- components.lua --
--------------------
-- NIL

------------------
-- conduits.lua --
------------------
-- if any are false also disables craft recipe
-- uses conduit_dirt_with_grass
-- uses conduit_dirt_with_dry_grass
-- uses conduit_stone_block
-- uses conduit_stone_block_desert
-- uses tools.enable_iron_tools
-- uses tools.enable_lead_tools
-- uses graphic.grass
-- uses graphic.dirt
-- uses graphic.grass_side
-- uses graphic.grass_dry
-- uses graphic.grass_side_dry
-- uses graphic.stone_block
-- uses graphic.desert_stone_block
-- uses sounds.node_sound_dirt_c
-- uses .sounds.node_sound_stone

------------------
-- crafting.lua --
------------------
-- uses ing.group_stick
-- uses ing.group_stone
-- uses ing.group_color_red
-- uses ing.group_color_green
-- uses ing.group_color_blue
-- uses ing.group_color_black
-- uses ing.group_color_violet
-- uses ing.dirt
-- uses ing.wheat
-- uses ing.slab_stone_block
-- uses ing.slab_desert_stone_block
-- uses ing.glass
-- uses ing.seed_wheat
-- uses ing.iron_lump
-- uses ing.coal_lump
-- uses ing.copper_ingot
-- uses ing.silver_ingot
-- uses ing.gold_ingot
-- uses ing.tin_ingot
-- uses ing.bronze_ingot
-- uses ing.steel_ingot
-- uses ing.mese_crystal
-- uses ing.mese_crystal_fragment
-- uses ing.mese_lamp

-- uses tools.enable_iron_tools
-- uses tools.enable_lead_tools

--------------------
-- craftitems.lua --
--------------------
-- uses ing.water_source
-- uses ing.steel_ingot

----------------
-- fluids.lua --
----------------
-- uses ing.water_source

-----------------------
-- gas_container.lua --
-----------------------
-- NIL

----------------
-- nodes.lua --
---------------
-- uses graphic.stone
-- uses graphic.obsidian_glass
-- uses sounds.node_sound_stone
-- uses sounds.node_sound_wood
-- uses sounds.node_sound_glass
-- uses sounds.node_sound_metal

---------------
-- tanks.lua --
---------------

-- NIL

---------------
-- tools.lua --
---------------
-- not registered if "ele.external.tools.enable_lead_tools = false" and "ele.external.tools.enable_iron_tools = false"
-- uses sounds.tool_breaks


------------------
-- worldgen.lua --
------------------
-- uses ing.stone

----------------------
-- subfolder compat --
----------------------
-------------------------
-- basic_materials.lua --
-------------------------
-- uses ing.copper_ingot
-- uses ing.silver_ingot
-- uses ing.steel_ingot
-- uses ing.mese_crystal_fragment

------------------------------------------------------------
--            ___ _                                       --
--           | __| |___ _ __  _____ __ _____ _ _          --
--           | _|| / -_) '_ \/ _ \ V  V / -_) '_|         --
--           |___|_\___| .__/\___/\_/\_/\___|_|           --
--            __  __   |_|   _    _                       --
--           |  \/  |__ _ __| |_ (_)_ _  ___ ___          --
--           | |\/| / _` / _| ' \| | ' \/ -_|_-<          --
--           |_|  |_\__,_\__|_||_|_|_||_\___/__/          --
------------------------------------------------------------
--   Other mods nodes/items used by elepower_machines     --
------------------------------------------------------------
---------------
-- craft.lua --
---------------
-- NIL


------------------
-- crafting.lua --
------------------
-- uses ing.steel_ingot
-- uses ing.copper_ingot
-- uses ing.tin_ingot
-- uses ing.bronze_ingot
-- uses ing.gold_ingot
-- uses ing.silver_ingot
-- uses ing.coal_lump
-- uses ing.wheat
-- uses ing.mese_crystal
-- uses ing.mese_crystal_fragment
-- uses ing.group_stick
-- uses ing.group_stone
-- uses ing.glass
-- uses ing.obsidian_glass
-- uses ing.flour
-- uses ing.sand
-- uses ing.desert_sand
-- uses ing.cobble
-- uses ing.gravel
-- uses ing.mese
-- uses ing.group_wood
-- uses ing.brick
-- uses ing.flint
-- uses ing.clay_brick
-- uses ing.steel_block

--------------------
-- craftitems.lua --
--------------------
-- NIL

---------------
-- nodes.lua --
---------------
-- NIL

-------------------
-- upgrading.lua --
-------------------
-- NIL

------------------------
-- subfolder machines --
------------------------
---------------------
-- accumulator.lua --
---------------------
-- uses ing.water_source

---------------------
-- alloy_furnace.lua --
---------------------
-- NIL

---------------------
-- bucketer.lua --
---------------------
-- NIL

-------------------------
-- canning_machine.lua --
-------------------------
-- NIL

----------------------------
-- coal_alloy_furnace.lua --
----------------------------
-- uses graphic.furnace_fire_bg
-- uses graphic.furnace_fire_fg
-- uses graphic.gui_furnace_arrow_bg
-- uses graphic.gui_furnace_arrow_fg

-------------------------
-- compressor.lua --
-------------------------
-- NIL

----------------------
-- electrolyzer.lua --
----------------------
-- uses ing.water_source

--------------------
-- evaporator.lua --
--------------------
-- uses graphic.gui_furnace_arrow_bg

---------------------
-- fuel_burner.lua --
---------------------
-- NIL

-----------------
-- furnace.lua --
-----------------
-- NIL

-------------------
-- generator.lua --
-------------------
-- NIL

--------------------
-- grindstone.lua --
--------------------
-- uses graphic.gui_furnace_arrow_fg
-- uses graphic.gui_furnace_arrow_bg
-- uses graphic.wood

---------------------
-- lava_cooler.lua --
---------------------
-- uses ing.cobble
-- uses ing.stone
-- uses ing.water_source
-- uses graphic.gui_furnace_arrow_fg
-- uses graphic.gui_furnace_arrow_bg
-- uses ing.obsidian
-- uses ing.lava_source

------------------------
-- lava_generator.lua --
------------------------
-- uses ing.lava_source

-------------------
-- pcb_plant.lua --
-------------------
-- uses graphic.gui_furnace_arrow_fg
-- uses graphic.gui_furnace_arrow_bg

--------------------
-- pulverizer.lua --
--------------------
-- NIL

--------------
-- pump.lua --
--------------
-- uses ing.water_source

-----------------
-- sawmill.lua --
-----------------
-- NIL

------------------
-- solderer.lua --
------------------
-- NIL

-----------------------
-- steam_turbine.lua --
-----------------------
-- NIL

-----------------
-- storage.lua --
-----------------

----------------------
-- wind_turbine.lua --
----------------------
-- uses graphic.wood

---------------------
-- subfolder bases --
---------------------
-----------------
-- crafter.lua --
-----------------
-- NIL

-------------------------
-- fluid_generator.lua --
-------------------------
-- uses graphic.gui_furnace_arrow_fg
-- uses graphic.gui_furnace_arrow_bg

-------------------
-- generator.lua --
-------------------
-- NIL

-----------------
-- storage.lua --
-----------------
-- NIL

---------------------------------------------------------------
--  ___ _                                _____         _     --
-- | __| |___ _ __  _____ __ _____ _ _  |_   _|__  ___| |___ --
-- | _|| / -_) '_ \/ _ \ V  V / -_) '_|   | |/ _ \/ _ \ (_-< --
-- |___|_\___| .__/\___/\_/\_/\___|_|     |_|\___/\___/_/__/ --
--           |_|                                             --
---------------------------------------------------------------
--      Other mods nodes/items used by elepower_tools        --
---------------------------------------------------------------
---------------
-- armor.lua --
---------------
-- uses armor.enable_iron_armor
-- uses armor.enable_carbon_fiber_armor


------------------
-- crafting.lua --
------------------
--[[ Uses
		ing.steel_ingot
		ing.mese
--]]
-- uses ing.diamond_block

--------------------
-- craftitems.lua --
--------------------
-- NIL

--------------------------
-- ed_reconstructor.lua --
--------------------------
-- NIL

-------------------
-- soldering.lua --
-------------------
-- NIL

---------------
-- tools.lua --
---------------
-- NIL

------------------------------------------------------------
--            ___ _                                       --
--           | __| |___ _ __  _____ __ _____ _ _          --
--           | _|| / -_) '_ \/ _ \ V  V / -_) '_|         --
--           |___|_\___| .__/\___/\_/\_/\___|_|           --
--            ___      |_|      _                         --
--           | __|_ _ _ _ _ __ (_)_ _  __ _               --
--           | _/ _` | '_| '  \| | ' \/ _` |              --
--           |_|\__,_|_| |_|_|_|_|_||_\__, |              --
--                                    |___/               --
------------------------------------------------------------
--    Other mods nodes/items used by elepower_farming     --
------------------------------------------------------------
------------------
-- crafting.lua --
------------------
-- uses ing.glass
-- uses ing.mese_crystal
-- uses ing.hoe_steel
-- uses ing.axe_steel

--------------------
-- craftitems.lua --
--------------------
-- NIL

----------------
-- fluids.lua --
----------------
-- NIL

---------------
-- nodes.lua --
---------------
-- NIL

--------------------
-- treecutter.lua --
--------------------
-- uses ing.tree
-- uses ing.leaves
-- uses ing.apple
-- uses ing.jungle_tree
-- uses ing.jungle_leaves
-- uses ing.pine_tree
-- uses ing.pine_needles
-- uses ing.acacia_tree
-- uses ing.acacia_leaves
-- uses ing.aspen_tree
-- uses ing.aspen_leaves

-- treecutter optionally supports mods farming_plus, ethereal and moretrees

------------------------
-- subfolder machines --
------------------------
-------------------
-- composter.lua --
-------------------
-- NIL

-------------------
-- harvester.lua --
-------------------
-- NIL

-----------------
-- planter.lua --
-----------------
-- uses sounds.dig_crumbly
-- uses ing.farming_soil
-- uses ing.farming_soil_wet

-----------------
-- spawner.lua --
-----------------
-- NIL

------------------------
-- tree_extractor.lua --
------------------------
-- uses ing.tree
-- uses ing.jungle_tree
-- uses ing.pine_tree
-- uses ing.acacia_tree
-- uses ing.aspen_tree

------------------------
-- tree_processor.lua --
------------------------
-- uses ing.water_source

------------------------------------------------------------
--           ___ _                                        --
--          | __| |___ _ __  _____ __ _____ _ _           --
--          | _|| / -_) '_ \/ _ \ V  V / -_) '_|          --
--          |___|_\___| .__/\___/\_/\_/\___|_|            --
--                 ___|_|   _                             --
--                / __| ___| |__ _ _ _                    --
--                \__ \/ _ \ / _` | '_|                   --
--                |___/\___/_\__,_|_|                     --
------------------------------------------------------------
--      Other mods nodes/items used by elepower_solar     --
------------------------------------------------------------
------------------
-- crafting.lua --
------------------
-- uses ing.glass
-- uses ing.steel_ingot

-------------------
-- generator.lua --
-------------------
-- NIL

----------------
-- helmet.lua --
----------------
--NIL

------------------
-- register.lua --
------------------
--NIL

------------------------------------------------------------
--            ___ _                                       --
--           | __| |___ _ __  _____ __ _____ _ _          --
--           | _|| / -_) '_ \/ _ \ V  V / -_) '_|         --
--           |___|_\___| .__/\___/\_/\_/\___|_|           --
--             _____ _ |_|                   _            --
--            |_   _| |_  ___ _ _ _ __  __ _| |           --
--              | | | ' \/ -_) '_| '  \/ _` | |           --
--              |_| |_||_\___|_| |_|_|_\__,_|_|           --
------------------------------------------------------------
--    Other mods nodes/items used by elepower_thermal     --
------------------------------------------------------------
------------------
-- crafting.lua --
------------------
-- NIL

----------------
-- fluids.lua --
----------------
-- NIL

------------------------
-- subfolder machines --
------------------------
---------------------------
-- evaporation_plant.lua --
---------------------------
-- uses ing.water_source
-- uses ref.gui_slots

------------------------------------------------------------
--          ___ _                                         --
--         | __| |___ _ __  _____ __ _____ _ _            --
--         | _|| / -_) '_ \/ _ \ V  V / -_) '_|           --
--         |___|_\___| .__/\___/\_/\_/\___|_|             --
--              __  _|_|      _                           --
 --            |  \/  (_)_ _ (_)_ _  __ _                 --
--             | |\/| | | ' \| | ' \/ _` |                --
--             |_|  |_|_|_||_|_|_||_\__, |                --
--                                  |___/                 --
------------------------------------------------------------
--     Other mods nodes/items used by elepower_mining     --
------------------------------------------------------------
------------------
-- crafting.lua --
------------------
-- uses ing.steel_block

---------------
-- miner.lua --
---------------
-- uses ing.water_source
-- uses ing.stone

------------------------------------------------------------
--           ___ _                                        --
--          | __| |___ _ __  _____ __ _____ _ _           --
--          | _|| / -_) '_ \/ _ \ V  V / -_) '_|          --
--          |___|_\___| .__/\___/\_/\_/\___|_|            --
--              _  _  |_|    _                            --
--             | \| |_  _ __| |___ __ _ _ _               --
--             | .` | || / _| / -_) _` | '_|              --
--             |_|\_|\_,_\__|_\___\__,_|_|                --
------------------------------------------------------------
--     Other mods nodes/items used by elepower_nuclear    --
------------------------------------------------------------
------------------
-- crafting.lua --
------------------
-- uses ing.steel_block
-- uses ing.silver_ingot

--------------------
-- craftitems.lua --
--------------------
-- NIL

----------------
-- fluids.lua --
----------------
-- NIL

---------------
-- nodes.lua --
---------------
-- uses graphic.stone
-- uses sounds.node_sound_stone

------------------
-- worldgen.lua --
------------------
-- uses ing.stone

------------------------
-- subfolder machines --
------------------------

-------------------------
--enrichment_plant.lua --
-------------------------
-- NIL

-------------------------
-- fission_reactor.lua --
-------------------------
-- uses ing.lava_source
-- uses ing.water_source

------------------------
-- fusion_reactor.lua --
------------------------
-- uses ref.gui_slots

------------------------
-- heat_exchanger.lua --
------------------------
-- uses ing.water_source
-- uses graphic.gui_furnace_arrow_bg

---------------------------------
-- solar_neutron_activator.lua --
---------------------------------
-- uses graphic.gui_furnace_arrow_bg
-- uses graphic.gui_furnace_arrow_fg

------------------------------------------------------------
--            ___ _                                       --
--           | __| |___ _ __  _____ __ _____ _ _          --
--           | _|| / -_) '_ \/ _ \ V  V / -_) '_|         --
--           |___|_\___| .__/\___/\_/\_/\___|_|           --
--             __      |_|         _                      --
--             \ \    / (_)_ _ ___| |___ ______           --
--              \ \/\/ /| | '_/ -_) / -_|_-<_-<           --
--               \_/\_/ |_|_| \___|_\___/__/__/           --
------------------------------------------------------------
--    Other mods nodes/items used by elepower_wireless    --
------------------------------------------------------------
------------------
-- crafting.lua --
------------------
-- uses ing.steel_block

--------------------
-- craftitems.lua --
--------------------
-- NIL

------------------------
-- subfolder machines --
------------------------
-----------------
-- dialler.lua --
-----------------
-- NIL

-------------------------
-- matter_receiver.lua --
-------------------------
-- NIL

----------------------------
-- matter_transmitter.lua --
----------------------------
-- NIL

-----------------
-- station.lua --
-----------------
-- NIL

-------------------
-- tesseract.lua --
-------------------
-- NIL

-----------------------
-- subfolder station --
-----------------------

-------------------------
-- fission_reactor.lua --
-------------------------
-- NIL

------------------------------------------------------------
--             ___ _                                      --
--            | __| |___ _ __  _____ __ _____ _ _         --
--            | _|| / -_) '_ \/ _ \ V  V / -_) '_|        --
--            |___|_\___| .__/\___/\_/\_/\___|_|          --
--              _  (_)  |_| _   _   _                     --
--             | |  (_)__ _| |_| |_(_)_ _  __ _           --
--             | |__| / _` | ' \  _| | ' \/ _` |          --
--             |____|_\__, |_||_\__|_|_||_\__, |          --
--                    |___/               |___/           --
------------------------------------------------------------
--    Other mods nodes/items used by elepower_lighting    --
------------------------------------------------------------
--------------------
-- i_crafting.lua --
--------------------
-- uses ing.glass
-- uses ing.slab_glass
-- uses ing.slab_wood
-- uses ing.stick
-- uses ing.dye_red
-- uses ing.dye_green
-- uses ing.dye_blue

---------------------------
-- i_crafting_shades.lua --
---------------------------
-- uses ing.glass
-- uses ing.dye_red
-- uses ing.dye_blue
-- uses ing.paper

----------------------
-- i_craftitems.lua --
----------------------
--NIL

---------------------
-- i_functions.lua --
---------------------
--NIL

---------------------------------
-- i_register_flood_lights.lua --
---------------------------------
--NIL

--------------------------
-- i_register_nodes.lua --
--------------------------
--NIL

---------------------------------
-- i_register_nodes_shades.lua --
---------------------------------
--NIL

------------------------------------------------------------
--            ___ _                                       --
--           | __| |___ _ __  _____ __ _____ _ _          --
--           | _|| / -_) '_ \/ _ \ V  V / -_) '_|         --
--           |___|_\___| .__/\___/\_/\_/\___|_|           --
--                     |_|                                --
--                    _____                               --
--                   |_   _|__ _ __  ___                  --
--                     | |/ _ \ '  \/ -_)                 --
--                     |_|\___/_|_|_\___|                 --
------------------------------------------------------------
--      Other mods nodes/items used by elepower_tome      --
------------------------------------------------------------
-----------------------------------
-- i_eletome_additional_info.lua --
-----------------------------------
-- uses ing.copper_ingot
-- uses ing.steel_ingot
-- uses ing.gold_ingot
-- uses ing.tin_ingot
-- uses ing.mese_crystal_fragment
-- uses ing.mese_crystal
-- uses ing.coal_lump
-- uses ing.sand
-- uses ing.glass
-- uses ing.lava_source
-- uses ing.stone
-- uses ing.water_source
-- uses ing.blueberry_bush_leaves
-- uses ing.furnace
-- uses graphic.farming_wheat
-- uses graphic.farming_wheat_seed

---------------------
-- i_functions.lua --
---------------------
--NIL

-------------------------
-- i_page_contents.lua --
-------------------------
--NIL

-----------------------
-- i_page_crafts.lua --
-----------------------
--NIL

---------------------
-- i_page_help.lua --
---------------------
--NIL

-----------------------------
-- i_page_instructions.lua --
-----------------------------
--NIL

-------------------------
-- i_page_machines.lua --
-------------------------
--NIL
