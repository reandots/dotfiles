-- Скрипты Quake-терминала и его анимации
local directory = assert(debug.getinfo(1, "S").source:match("^@(.+)/[^/]+$"))
local config = {
    terminal = "kitty",
    scripts = directory .. "/scripts",
}

require("env")
require("startup")(config)
require("monitor")
require("layout")
require("look")
require("input")
require("keybind")(config)
require("window_rules")
require("workspaces")
