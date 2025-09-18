
ele.worldgen = {
  miner_ore_y_min = -30912,
  miner_ore_y_max = 0,
  miner_ore_rarity = 1.16,
}
ele.worldgen.ore = {}
ele.worldgen.ore.lead = {
  high = {
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 12,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  },
  normal = {
    clust_scarcity = 14 * 14 * 14,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 0,
    y_min          = -31000,
  },
  deep = {
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -128,
    y_min          = -31000,
  }
}
ele.worldgen.ore.nickel = {
  high = {
    clust_scarcity = 25 * 25 * 25,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = 0,
    y_min          = -31000,
  },
  normal = {
    clust_scarcity = 25 * 25 * 25,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 0,
  },
  deep = {
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -1028,
    y_min          = -31000,
  },
  superdeep = {
    clust_scarcity = 12 * 12 * 12,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -8096,
    y_min          = -31000,
  }
}
ele.worldgen.ore.viridisium = {
  high = {
    clust_scarcity = 25 * 25 * 25,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -1028,
    y_min          = -31000,
  },
  normal = {
    clust_scarcity = 20 * 20 * 20,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -8096,
    y_min          = -31000,
  },
  deep = {
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -12000,
    y_min          = -31000,
  }
}
ele.worldgen.ore.zinc = {
  high = {
    clust_scarcity = 25 * 25 * 25,
    clust_num_ores = 2,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = -31000,
  },
  normal = {
    clust_scarcity = 20 * 20 * 20,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 0,
    y_min          = -31000,
  },
  deep = {
    clust_scarcity = 12 * 12 * 12,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -256,
    y_min          = -31000,
  }
}
-- Only generated if elepower_nuclear is loaded
ele.worldgen.ore._uranium = {
  high = {
    clust_scarcity = 16 * 16 * 16,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 846,
    y_min          = 248,
  },
  normal = {
    clust_scarcity = 16 * 16 * 16,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -248,
    y_min          = -846,
  },
  deep = {
    clust_scarcity = 16 * 16 * 16,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -1248,
    y_min          = -1846,
  }
}
