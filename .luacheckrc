read_globals = {
    "DIR_DELIM", "INIT",

    "minetest", "core",
    "dump", "dump2",

    "Raycast",
    "Settings",
    "PseudoRandom",
    "PerlinNoise",
    "VoxelManip",
    "SecureRandom",
    "VoxelArea",
    "PerlinNoiseMap",
    "PcgRandom",
    "ItemStack",
    "AreaStore",

    "vector",

    table = {
        fields = {
            "copy",
            "indexof",
            "insert_all",
            "key_value_swap",
            "shuffle",
        }
    },

    string = {
        fields = {
            "split",
            "trim",
        }
    },

    math = {
        fields = {
            "hypot",
            "sign",
            "factorial"
        }
    },

    -- external mods
    "default",
    "armor",
    "player_ui",
    "sfinv",
    "player_api",
    "tubelib",

    fluid_tanks = {
        fields = {
            "register_tank"
        },
    },

    bucket = {
        fields = {
            "register_liquid",
            "liquids",
            "get_liquid_for_bucket",
        }
    },

    fluid_lib = {
        fields = {
            "unit",
            "transfer_timer_tick",
            "refresh_node",
            "register_transfer_node",
            "register_extractor_node",
            "register_node",
            "get_buffer_data",
            "get_node_buffers",
            "insert_into_buffer",
            "can_take_from_buffer",
            "take_from_buffer",
            "can_insert_into_buffer",
            "buffer_accepts_fluid",
            "cleanse_node_description",
            "buffer_to_string",
            "comma_value",
            "cleanse_node_name",
            "get_empty_bucket",
            "get_liquid_list",
            "get_flowing_for_source",
            "get_bucket_for_source",
            "get_source_for_bucket"
        },
    },
}
globals = {
    ele = {
        fields = {
            external = {
                fields = {
                    "ref",
                    "ing",
                    "tools",
                    "armor",
                    "sounds",
                    "graphic",
                    "conduit_dirt_with_grass",
                    "conduit_dirt_with_dry_grass",
                    "conduit_stone_block",
                    "conduit_stone_block_desert",
                }
            },
            "api_standalone",
            "translator",
            "worldgen",
            "graphcache",
            "clear_networks",
            "modpath",
            "unit",
            "unit_description",
            "formspec",
            "helpers",
            "default",
            "tools",
            "gases",
            "capacity_text",
            "get_gas_for_container",
            "get_machine_owner",
            "register_conduit",
            "register_gas",
            "register_base_device",
            "register_machine",
            "register_fluid_generator",
            "register_wind_generator",
            "register_tool"
        }
    },

    -- elepower components
    "elepd",
    "elefarm",
    "elepower_lighting",
    "elepm",
    "elemining",
    "elenuclear",
    "elesolar",
    "elethermal",
    "eletome",
    "eletool",
    "elewi",
}
