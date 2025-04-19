
local epi = ele.external.ing
local epg = ele.external.graphic
local eps = ele.external.sounds

-------------------------------------------------
-- Ingredients or node item references in code --
-------------------------------------------------
local ingot = "moreores:silver_ingot"

if epi.silver_ingot == "" then
  epi.silver_ingot = ingot
end

if core.get_modpath("moreores") == nil then
  core.register_craftitem(":moreores:silver_ingot", {
    description = "Silver Ingot",
    inventory_image = "elepower_silver_ingot.png",
    groups = {silver = 1, ingot = 1}
  })

  core.register_craftitem(":moreores:silver_lump", {
    description = "Silver Lump",
    inventory_image = "elepower_silver_lump.png",
    groups = {silver = 1, lump = 1}
  })

  core.register_node(":moreores:mineral_silver", {
    description = "Silver Ore",
    tiles = {epg.stone.."^elepower_mineral_silver.png"},
    groups = {cracky = 1, pickaxey = 4, material_stone = 1},
    drop = 'moreores:silver_lump',
    sounds = eps.node_sound_stone,
    _mcl_blast_resistance = 3,
    _mcl_hardness = 3,
    _mcl_silk_touch_drop = true,
  })

  core.register_node(":moreores:silver_block", {
    description = "Silver Block",
    tiles = {"elepower_silver_block.png"},
    is_ground_content = false,
    groups = {cracky = 2, pickaxey = 2, level = 2},
    sounds = eps.node_sound_metal,
  })

  core.register_craft({
    type   = "cooking",
    output = ingot,
    recipe = "moreores:silver_lump"
  })

  core.register_craft({
    output = "moreores:silver_block",
    recipe = {
      { ingot, ingot, ingot },
      { ingot, ingot, ingot },
      { ingot, ingot, ingot },
    }
  })

  core.register_craft({
    output = ingot .. " 9",
    recipe = {
      { "moreores:silver_block" },
    }
  })

  if core.get_modpath("mcl_core") == nil then
    ele.worldgen.ore.silver = {
      high = {
        clust_scarcity = 11 ^ 3,
        clust_num_ores = 4,
        clust_size = 3,
        y_min = 1025,
        y_max = 31000,
      },
      normal = {
        clust_scarcity = 13 ^ 3,
        clust_num_ores = 2,
        clust_size = 3,
        y_min = -127,
        y_max = -64,
      },
      deep = {
        clust_scarcity = 11 ^ 3,
        clust_num_ores = 4,
        clust_size = 3,
        y_min = -31000,
        y_max = -128,
      },
    }
  else
    ele.worldgen.ore.silver = {
      high = {
        clust_scarcity = 11 ^ 3,
        clust_num_ores = 4,
        clust_size = 3,
        y_min = -10,
        y_max = 0,
      },
      normal = {
        clust_scarcity = 13 ^ 3,
        clust_num_ores = 2,
        clust_size = 3,
        y_min = -57,
        y_max = -11,
      },
      deep = {
        clust_scarcity = 11 ^ 3,
        clust_num_ores = 4,
        clust_size = 3,
        y_min = -31000,
        y_max = -128,
      },
    }
  end
end

core.register_alias("elepower_dynamics:silver_block", "moreores:silver_block")
core.register_alias("elepower_dynamics:silver_ingot", ingot)
core.register_alias("elepower_dynamics:silver_lump", "moreores:silver_lump")
core.register_alias("elepower_dynamics:stone_with_silver", "moreores:mineral_silver")
