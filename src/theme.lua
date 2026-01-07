-- src/theme.lua
local Theme = {}

Theme.themes = {
    [1] = {
        name = "Bob-omb Battlefield",
        background = {0.53, 0.81, 0.92}, -- Sky Blue
        grid = {0.2, 0.3, 0.2},
        empty = {0.3, 0.35, 0.3},
        text = {1, 1, 1},
        score = {0.1, 0.1, 0.1},
        tiles = {
            [2] = {0.4, 0.8, 0.4}, -- Light Green
            [4] = {0.2, 0.6, 0.2}, -- Dark Green
            [8] = {0.9, 0.8, 0.6}, -- Beige
            [16] = {0.6, 0.4, 0.2}, -- Brown
            [32] = {0.4, 0.2, 0.1}, -- Dark Brown
            [64] = {0.5, 0.5, 0.5}, -- Grey
            [128] = {0.3, 0.3, 0.3}, -- Dark Grey
            [256] = {0.1, 0.1, 0.1}, -- Black
            [512] = {1.0, 0.4, 0.7}, -- Pink
            [1024] = {1.0, 0.84, 0.0}, -- Gold
            [2048] = {1.0, 1.0, 0.2}, -- Star Yellow
        }
    },
    [2] = {
        name = "Lethal Lava Land",
        background = {0.4, 0.0, 0.0}, -- Dark Red
        grid = {0.2, 0.0, 0.0},
        empty = {0.3, 0.1, 0.1},
        text = {1, 1, 1},
        score = {1, 1, 0.8},
        tiles = {
            [2] = {1.0, 0.3, 0.0}, -- Orange
            [4] = {0.9, 0.1, 0.0}, -- Red
            [8] = {0.6, 0.0, 0.0}, -- Dark Red
            [16] = {0.4, 0.0, 0.0}, -- Very Dark Red
            [32] = {0.2, 0.0, 0.0}, -- Blackish Red
            [64] = {0.3, 0.3, 0.3}, -- Grey Ash
            [128] = {0.1, 0.1, 0.1}, -- Obsidian
            [256] = {1.0, 0.0, 0.0}, -- Bright Red
            [512] = {1.0, 0.5, 0.0}, -- Magma
            [1024] = {1.0, 0.8, 0.0}, -- Gold
            [2048] = {1.0, 1.0, 1.0}, -- White Hot
        }
    },
    [3] = {
        name = "Cool, Cool Mountain",
        background = {0.0, 0.1, 0.3}, -- Deep Blue
        grid = {0.0, 0.2, 0.4},
        empty = {0.0, 0.25, 0.5},
        text = {0, 0, 0.2},
        score = {0.8, 0.9, 1.0},
        tiles = {
            [2] = {0.8, 0.9, 1.0}, -- Ice White
            [4] = {0.6, 0.8, 1.0}, -- Light Cyan
            [8] = {0.4, 0.7, 1.0}, -- Cyan
            [16] = {0.2, 0.5, 0.9}, -- Blue
            [32] = {0.1, 0.3, 0.7}, -- Dark Blue
            [64] = {0.5, 0.5, 0.8}, -- Blue Grey
            [128] = {0.3, 0.3, 0.6}, -- Dark Blue Grey
            [256] = {0.1, 0.1, 0.4}, -- Deepest Blue
            [512] = {0.6, 0.0, 0.8}, -- Purple
            [1024] = {0.8, 0.8, 1.0}, -- Crystal
            [2048] = {0.0, 1.0, 1.0}, -- Diamond Cyan
        }
    }
}

return Theme
