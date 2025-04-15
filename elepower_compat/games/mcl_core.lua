
if minetest.get_modpath("mcl_core") ~= nil then
  -------------
  -- General --
  -------------
  ele.external.tools.enable_iron_tools         = false
  ele.external.tools.enable_lead_tools         = true
  ele.external.armor.enable_iron_armor         = false
  ele.external.armor.enable_carbon_fiber_armor = true

  ele.external.conduit_dirt_with_grass      = false
  ele.external.conduit_dirt_with_dry_grass  = false
  ele.external.conduit_stone_block          = false
  ele.external.conduit_stone_block_desert   = false

  ----------------
  -- References --
  ----------------
  ele.external.ref.get_itemslot_bg  = mcl_formspec.get_itemslot_bg_v4
  ele.external.ref.player_inv_width = 9
  ele.external.ref.gui_player_inv   = function(center_on, y)
                y = y or 5
                center_on = center_on or 11.75
                local x = center_on / 2 - ((8 * 0.25) + 9) / 2
                return mcl_formspec.get_itemslot_bg_v4(x, y, 9, 3)..
                       "list[current_player;main;"..x..","..y..";9,3;9]" ..
                       mcl_formspec.get_itemslot_bg_v4(x, y + 4, 9, 1)..
                       "list[current_player;main;"..x..","..(y + 4)..";9,1;]"
  end

  -------------------------------------------------
  -- Ingredients or node item references in code --
  -------------------------------------------------
  ele.external.ing.water_source       = "mcl_core:water_source"
  ele.external.ing.stone              = "mcl_core:stone"
  ele.external.ing.group_stick        = "group:stick"
  ele.external.ing.group_stone        = "group:stone"
  ele.external.ing.group_color_red    = "group:color_red"
  ele.external.ing.group_color_green  = "group:color_green"
  ele.external.ing.group_color_blue   = "group:color_blue"
  ele.external.ing.group_color_black  = "group:color_black"
  ele.external.ing.group_color_violet = "group:color_violet"
  ele.external.ing.group_wood         = "group:wood"

  ele.external.ing.dirt          = "mcl_core:dirt"       -- only used by conduit_dirt_with_grass/dry_grass
  ele.external.ing.wheat         = "mcl_farming:wheat"      -- only used by conduit_dirt_with_dry_grass
  ele.external.ing.glass         = "mcl_core:glass"
  ele.external.ing.seed_wheat    = "mcl_farming:wheat_seeds" -- essential to acidic compound
  ele.external.ing.iron_lump     = "mcl_raw_ores:raw_iron"
  ele.external.ing.coal_lump     = "mcl_core:coal_lump"
  ele.external.ing.copper_ingot  = "mcl_copper:copper_ingot"
  ele.external.ing.gold_ingot    = "mcl_core:gold_ingot"
  ele.external.ing.tin_ingot     = "" --- not supported by game
  ele.external.ing.bronze_ingot  = "" --- not supported by game
  ele.external.ing.iron_ingot    = "mcl_core:iron_ingot"
  ele.external.ing.iron_block    = "mcl_core:ironblock"
  ele.external.ing.steel_ingot   = "" -- not supported by game
  ele.external.ing.steel_block   = "" -- not supported by game
  ele.external.ing.diamond_block = "mcl_core:diamondblock"
  ele.external.ing.mese          = "mesecons_torch:redstoneblock"
  ele.external.ing.mese_crystal  = "mesecons:redstone"
  ele.external.ing.mese_crystal_fragment = "mesecons:redstone"
  ele.external.ing.mese_lamp     = "mesecons_lightstone:lightstone_off"
  ele.external.ing.flour         = "mcl_farming:flour"
  ele.external.ing.sand          = "mcl_core:sand"
  ele.external.ing.desert_sand   = "mcl_nether:soul_sand"
  ele.external.ing.cobble        = "mcl_core:cobble"
  ele.external.ing.gravel        = "mcl_core:gravel"
  ele.external.ing.brick         = "mcl_core:brick_block"
  ele.external.ing.flint         = "mcl_core:flint"
  ele.external.ing.clay_brick    = "mcl_core:brick"
  ele.external.ing.obsidian      = "mcl_core:obsidian"
  ele.external.ing.lava_source   = "mcl_core:lava_source"
  ele.external.ing.hoe_steel     = "mcl_farming:hoe_iron"
  ele.external.ing.axe_steel     = "mcl_tools:axe_iron"
  ele.external.ing.tree          = "mcl_core:wood"
  ele.external.ing.leaves        = "mcl_core:leaves"
  ele.external.ing.apple         = "mcl_core:apple"
  ele.external.ing.jungle_tree   = "mcl_core:jungletree"
  ele.external.ing.jungle_leaves = "mcl_core:jungleleaves"
  ele.external.ing.pine_tree     = "mcl_core:sprucetree"
  ele.external.ing.pine_needles  = "mcl_core:spruceleaves"
  ele.external.ing.acacia_tree   = "mcl_core:acaciatree"
  ele.external.ing.acacia_leaves = "mcl_core:acacialeaves"
  ele.external.ing.aspen_tree    = "mcl_core:birchwood"
  ele.external.ing.aspen_leaves  = "mcl_core:birchleaves"
  ele.external.ing.slab_wood     = "mcl_stairs:slab_wood"
  ele.external.ing.stick         = "mcl_core:stick"
  ele.external.ing.paper         = "mcl_core:paper"             -- elepower_lighting decorative shades only
  ele.external.ing.farming_soil  = "mcl_farming:soil"
  ele.external.ing.farming_soil_wet = "mcl_farming:soil_wet"
  ele.external.ing.slab_glass    = "xpanes:pane_natural_flat"
  ele.external.ing.dye_red       = "mcl_dye:red"
  ele.external.ing.dye_green     = "mcl_dye:green"
  ele.external.ing.dye_blue      = "mcl_dye:blue"
  ele.external.ing.furnace       = "mcl_furnaces:furnace"
  ele.external.ing.obsidian_glass = "mcl_core:obsidian"
  ele.external.ing.slab_stone_block = "mcl_stairs:slab_stonebrick"
  ele.external.ing.blueberry_bush_leaves = "mcl_core:leaves"
  ele.external.ing.slab_desert_stone_block = "mcl_stairs:slab_sandstone"

  ------------
  -- Sounds --
  ------------
  ele.external.sounds.node_sound_stone = mcl_sounds.node_sound_stone_defaults()
  ele.external.sounds.node_sound_water = mcl_sounds.node_sound_water_defaults()
  ele.external.sounds.node_sound_stone = mcl_sounds.node_sound_stone_defaults()
  ele.external.sounds.node_sound_wood  = mcl_sounds.node_sound_wood_defaults()
  ele.external.sounds.node_sound_glass = mcl_sounds.node_sound_glass_defaults()
  ele.external.sounds.node_sound_metal = mcl_sounds.node_sound_metal_defaults()
  ele.external.sounds.tool_breaks      = "default_tool_breaks"
  ele.external.sounds.dig_crumbly      = "default_dig_crumbly"
  ele.external.sounds.node_sound_dirt_c = mcl_sounds.node_sound_dirt_defaults(
                      {
                        footstep = {name = "default_grass_footstep", gain = 0.25}
                      })
  ---------------------
  -- Graphics/Images --
  ---------------------
  ele.external.graphic.water               = "default_water.png"
  ele.external.graphic.grass               = "default_dirt.png^mcl_core_grass_block_side_overlay.png"
  ele.external.graphic.dirt                = "default_dirt.png"
  ele.external.graphic.grass_side          = "default_dirt.png^mcl_dirt_grass_shadow.png"
  ele.external.graphic.grass_dry           = ""
  ele.external.graphic.grass_side_dry      = ""
  ele.external.graphic.stone_block         = "default_stone_brick.png"
  ele.external.graphic.desert_stone_block  = "mcl_core_sandstone_top.png"
  ele.external.graphic.stone               = "default_stone.png"
  ele.external.graphic.wood                = "default_wood.png"
  ele.external.graphic.obsidian_glass      = "default_obsidian.png"
  ele.external.graphic.furnace_fire_bg     = "default_furnace_fire_bg.png"
  ele.external.graphic.furnace_fire_fg     = "default_furnace_fire_fg.png"
  ele.external.graphic.gui_furnace_arrow_bg = "gui_furnace_arrow_bg.png"
  ele.external.graphic.gui_furnace_arrow_fg = "gui_furnace_arrow_fg.png"
  ele.external.graphic.gui_mesecons_on     = ""
  ele.external.graphic.gui_mesecons_off    = ""

  ----------------------
  -- World generation --
  ----------------------

  -- Adjust ore generation for VoxeLibre overworld
  ele.worldgen.ore.lead.normal.y_max = -24
  ele.worldgen.ore.lead.normal.y_min = -128

  ele.worldgen.ore.nickel.normal.y_max = -40
  ele.worldgen.ore.nickel.normal.y_min = -128

  ele.worldgen.ore.viridisium.normal.y_max = -50
  ele.worldgen.ore.viridisium.normal.y_min = -128

  ele.worldgen.ore.zinc.normal.y_max = -20
  ele.worldgen.ore.zinc.normal.y_min = -128

  ele.worldgen.ore._uranium.normal.y_max = -30
  ele.worldgen.ore._uranium.normal.y_min = -128
end
