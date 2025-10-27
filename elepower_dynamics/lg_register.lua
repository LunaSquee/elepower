ele = {worldgen = {}}
ele.worldgen.ore = core.ipc_get("elepower_dynamics:ore_parameters")

local O = mcl_levelgen.construct_ore_substitution_list
local uniform_height = mcl_levelgen.uniform_height
local overworld = mcl_levelgen.get_dimension("mcl_levelgen:overworld")

local floor = math.floor
local mathmax = math.max
local mathmin = math.min
local biomes = mcl_levelgen.build_biome_list({"#is_overworld"})

-- TODO: Deepslate ores

local function register_ore_feature(ore_name, def, mat, scatter)
    mcl_levelgen.register_configured_feature(ore_name, {
        feature = scatter and "mcl_levelgen:scatter_ore" or "mcl_levelgen:ore",
        discard_chance_on_air_exposure = 0.0,
        size = def.clust_size * 3,
        substitutions = O({
            {target = "group:stone_ore_target", replacement = mat}
        })
    })

    local start_y = mathmax(def.y_min + overworld.y_offset,
                            overworld.preset.min_y)
    local level_max_y = overworld.preset.min_y + overworld.preset.height - 1
    local end_y = mathmin(def.y_max + overworld.y_offset, level_max_y)
    local count_per_chunk = floor((1 / def.clust_scarcity) *
                                      ((end_y - start_y + 1) * 16 * 16))
    local count = function() return count_per_chunk end
    mcl_levelgen.register_placed_feature(ore_name, {
        configured_feature = ore_name,
        placement_modifiers = {
            mcl_levelgen.build_count(count), mcl_levelgen.build_in_square(),
            mcl_levelgen.build_height_range(uniform_height(start_y, end_y)),
            mcl_levelgen.build_in_biome()
        }
    })
    mcl_levelgen.generate_feature(ore_name, "mcl_levelgen:ore_diamond", biomes,
                                  mcl_levelgen.UNDERGROUND_ORES)
end

for mat, defs in pairs(ele.worldgen.ore) do
    if mat:sub(1, 1) ~= "_" then
        local ore_name = "elepower_dynamics:ore_" .. mat
        register_ore_feature(ore_name, defs.normal,
                             "elepower_dynamics:stone_with_" .. mat, false)
    end
end

ele.register_ore_feature = register_ore_feature

-- TODO: Validate elepower_nuclear is enabled

register_ore_feature("elepower_dynamics:ore_uranium",
                     ele.worldgen.ore._uranium.normal,
                     "elepower_nuclear:stone_with_uranium", true)
