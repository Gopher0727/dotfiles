local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- 默认启动 Arch WSL
config.default_domain = "WSL:archlinux"

-- 字体
config.font = wezterm.font("Maple Mono NF CN")
config.font_size = 12

-- 行号
config.line_height = 0.9

-- 窗口大小
config.initial_cols = 140
config.initial_rows = 35

-- 主题
-- config.color_scheme = "catppuccin-mocha"
config.color_scheme = "GruvboxDark"

-- 窗口外观
config.window_decorations = "RESIZE"

return config
