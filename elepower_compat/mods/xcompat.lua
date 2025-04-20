
if minetest.get_modpath("xcompat") ~= nil then
  local xmat = xcompat.materials
  local xsound = xcompat.sounds
  local ing_mappings = {
    water_source = xmat.water_source,
    stone = xmat.stone,
    dirt = xmat.dirt,
    wheat = xmat.wheat,
    glass = xmat.glass,
    seed_wheat = xmat.wheat_seeds,
    iron_lump = xmat.iron_lump,
    coal_lump = xmat.coal_lump,
    copper_ingot = xmat.copper_ingot,
    silver_ingot = xmat.silver_ingot,
    gold_ingot = xmat.gold_ingot,
    tin_ingot = xmat.tin_ingot,
    bronze_ingot = xmat.bronze_ingot,
    iron_ingot = xmat.iron_ingot,
    iron_block = xmat.iron_block,
    steel_ingot = xmat.steel_ingot,
    steel_block = xmat.steel_block,
    diamond_block = xmat.diamond_block,
    mese = xmat.mese,
    mese_crystal = xmat.mese_crystal,
    mese_crystal_fragment = xmat.mese_crystal_fragment,
    mese_lamp = xmat.mese_lamp,
    flour = xmat.flour,
    sand = xmat.sand,
    desert_sand = xmat.desert_sand,
    cobble = xmat.cobble,
    gravel = xmat.gravel,
    brick = xmat.brick,
    flint = xmat.flint,
    clay_brick = xmat.clay_brick,
    obsidian = xmat.obsidian,
    lava_source = xmat.lava_source,
    hoe_steel = xmat.hoe_steel,
    axe_steel = xmat.axe_steel,
    tree = xmat.apple_log,
    leaves = xmat.apple_leaves,
    apple = xmat.apple,
    jungle_tree = xmat.jungle_log,
    jungle_leaves = xmat.jungle_leaves,
    pine_tree = xmat.pine_tree,
    pine_needles = xmat.pine_needles,
    acacia_tree = xmat.acacia_log,
    acacia_leaves = xmat.acacia_leaves,
    aspen_tree = xmat.aspen_log,
    aspen_leaves = xmat.aspen_leaves,
    slab_wood = xmat.slab_wood,
    stick = xmat.stick,
    paper = xmat.paper,
    farming_soil = xmat.farming_soil,
    farming_soil_wet = xmat.farming_soil_wet,
    slab_glass = xmat.slab_glass,
    dye_red = xmat.dye_red,
    dye_green = xmat.dye_green,
    dye_blue = xmat.dye_blue,
    furnace = xmat.furnace,
    obsidian_glass = xmat.obsidian_glass,
    slab_stone_block = xmat.slab_stone_block,
    blueberry_bush_leaves = xmat.blueberry_bush_leaves,
    slab_desert_stone_block = xmat.slab_desert_stone_block,
  }

  local sound_mappings = {
    node_sound_water = xsound.node_sound_water_defaults,
    node_sound_stone = xsound.node_sound_stone_defaults,
    node_sound_wood = xsound.node_sound_wood_defaults,
    node_sound_glass = xsound.node_sound_grass_defaults,
    node_sound_metal = xsound.node_sound_metal_defaults,
    node_sound_dirt_c = xsound.node_sound_grass_defaults,
  }

  for elea,xcm in pairs(ing_mappings) do
    if xcm ~= nil and xcm ~= "" then
      ele.external.ing[elea] = xcm
    end
  end

  for elea,xcs in pairs(sound_mappings) do
    if xcs ~= nil and xcs ~= "" then
      ele.external.sounds[elea] = xcs()
    end
  end
end
