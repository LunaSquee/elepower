
if minetest.get_modpath("default") ~= nil then
  -------------
  -- General --
  -------------
  ele.external.tools.enable_iron_tools         = true
  ele.external.tools.enable_lead_tools         = true
  ele.external.armor.enable_iron_armor         = true
  ele.external.armor.enable_carbon_fiber_armor = true

  ele.external.conduit_dirt_with_grass      = true
  ele.external.conduit_dirt_with_dry_grass  = true
  ele.external.conduit_stone_block          = true
  ele.external.conduit_stone_block_desert   = true

  ----------------
  -- References --
  ----------------
  ele.external.ref.player_inv_width = 8

  -------------------------------------------------
  -- Ingredients or node item references in code --
  -------------------------------------------------
  ele.external.ing.group_stick        = "group:stick"
  ele.external.ing.group_stone        = "group:stone"
  ele.external.ing.group_color_red    = "group:color_red"
  ele.external.ing.group_color_green  = "group:color_green"
  ele.external.ing.group_color_blue   = "group:color_blue"
  ele.external.ing.group_color_black  = "group:color_black"
  ele.external.ing.group_color_violet = "group:color_violet"
  ele.external.ing.group_wood         = "group:wood"

  ele.external.ing.water_source  = "default:water_source"
  ele.external.ing.stone         = "default:stone"
  ele.external.ing.dirt          = "default:dirt"       -- only used by conduit_dirt_with_grass/dry_grass
  ele.external.ing.wheat         = "farming:wheat"      -- only used by conduit_dirt_with_dry_grass
  ele.external.ing.glass         = "default:glass"
  ele.external.ing.seed_wheat    = "farming:seed_wheat" -- essential to acidic compound
  ele.external.ing.iron_lump     = "default:iron_lump"
  ele.external.ing.coal_lump     = "default:coal_lump"
  ele.external.ing.copper_ingot  = "default:copper_ingot"
  ele.external.ing.gold_ingot    = "default:gold_ingot"
  ele.external.ing.tin_ingot     = "default:tin_ingot"
  ele.external.ing.bronze_ingot  = "default:bronze_ingot"
  ele.external.ing.iron_ingot    = "" -- not supported by game
  ele.external.ing.iron_block    = "" -- not supported by game
  ele.external.ing.steel_ingot   = "default:steel_ingot"
  ele.external.ing.steel_block   = "default:steelblock"
  ele.external.ing.diamond_block = "default:diamondblock"
  ele.external.ing.mese          = "default:mese"
  ele.external.ing.mese_crystal  = "default:mese_crystal"
  ele.external.ing.mese_crystal_fragment = "default:mese_crystal_fragment"
  ele.external.ing.mese_lamp     = "default:meselamp"
  ele.external.ing.flour         = "farming:flour"
  ele.external.ing.sand          = "default:sand"
  ele.external.ing.desert_sand   = "default:desert_sand"
  ele.external.ing.cobble        = "default:cobble"
  ele.external.ing.gravel        = "default:gravel"
  ele.external.ing.brick         = "default:brick"
  ele.external.ing.flint         = "default:flint"
  ele.external.ing.clay_brick    = "default:clay_brick"
  ele.external.ing.obsidian      = "default:obsidian"
  ele.external.ing.lava_source   = "default:lava_source"
  ele.external.ing.hoe_steel     = "farming:hoe_steel"
  ele.external.ing.axe_steel     = "default:axe_steel"
  ele.external.ing.tree          = "default:tree"
  ele.external.ing.leaves        = "default:leaves"
  ele.external.ing.apple         = "default:apple"
  ele.external.ing.jungle_tree   = "default:jungletree"
  ele.external.ing.jungle_leaves = "default:jungleleaves"
  ele.external.ing.pine_tree     = "default:pine_tree"
  ele.external.ing.pine_needles  = "default:pine_needles"
  ele.external.ing.acacia_tree   = "default:acacia_tree"
  ele.external.ing.acacia_leaves = "default:acacia_leaves"
  ele.external.ing.aspen_tree    = "default:aspen_tree"
  ele.external.ing.aspen_leaves  = "default:aspen_leaves"
  ele.external.ing.slab_wood     = "stairs:slab_wood"
  ele.external.ing.stick         = "default:stick"
  ele.external.ing.paper         = "default:paper"             -- elepower_lighting decorative shades only
  ele.external.ing.farming_soil  = "farming:soil"
  ele.external.ing.farming_soil_wet = "farming:soil_wet"
  ele.external.ing.slab_glass    = "stairs:slab_glass"
  ele.external.ing.dye_red       = "dye:red"
  ele.external.ing.dye_green     = "dye:green"
  ele.external.ing.dye_blue      = "dye:blue"
  ele.external.ing.furnace       = "default:furnace"
  ele.external.ing.obsidian_glass = "default:obsidian_glass"
  ele.external.ing.slab_stone_block = "stairs:slab_stone_block"
  ele.external.ing.blueberry_bush_leaves = "default:blueberry_bush_leaves"
  ele.external.ing.slab_desert_stone_block = "stairs:slab_desert_stone_block"

  ------------
  -- Sounds --
  ------------
  ele.external.sounds.node_sound_stone = default.node_sound_stone_defaults()
  ele.external.sounds.node_sound_water = default.node_sound_water_defaults()
  ele.external.sounds.node_sound_wood  = default.node_sound_wood_defaults()
  ele.external.sounds.node_sound_glass = default.node_sound_glass_defaults()
  ele.external.sounds.node_sound_metal = default.node_sound_metal_defaults()
  ele.external.sounds.tool_breaks      = "default_tool_breaks"
  ele.external.sounds.dig_crumbly      = "default_dig_crumbly"
  ele.external.sounds.node_sound_dirt_c = default.node_sound_dirt_defaults(
                      {
                        footstep = {name = "default_grass_footstep", gain = 0.25}
                      })
  ---------------------
  -- Graphics/Images --
  ---------------------
  ele.external.graphic.water                = "default_water.png"
  ele.external.graphic.grass                = "default_grass.png"
  ele.external.graphic.dirt                 = "default_dirt.png"
  ele.external.graphic.grass_side           = "default_grass_side.png"
  ele.external.graphic.grass_dry            = "default_dry_grass.png"
  ele.external.graphic.grass_side_dry       = "default_dry_grass_side.png"
  ele.external.graphic.stone_block          = "default_stone_block.png"
  ele.external.graphic.desert_stone_block   = "default_desert_stone_block.png"
  ele.external.graphic.stone                = "default_stone.png"
  ele.external.graphic.wood                 = "default_wood.png"
  ele.external.graphic.obsidian_glass       = "default_obsidian_glass.png"
  ele.external.graphic.furnace_fire_bg      = "default_furnace_fire_bg.png"
  ele.external.graphic.furnace_fire_fg      = "default_furnace_fire_fg.png"
  ele.external.graphic.gui_furnace_arrow_bg = "gui_furnace_arrow_bg.png"
  ele.external.graphic.gui_furnace_arrow_fg = "gui_furnace_arrow_fg.png"
  ele.external.graphic.gui_mesecons_on      = "mesecons_wire_on.png^elepower_gui_mese_mask.png^\\[makealpha\\:255,0,0"
  ele.external.graphic.gui_mesecons_off     = "mesecons_wire_off.png^elepower_gui_mese_mask.png^\\[makealpha\\:255,0,0"
  ele.external.graphic.farming_wheat        = "farming_wheat.png"
  ele.external.graphic.farming_wheat_seed   = "farming_wheat_seed.png"
end
