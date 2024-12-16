-- Load standard libraries
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local dpi = require("beautiful.xresources").apply_dpi

-- Error handling
require("configs.error_handling")

-- Variable definitions
terminal = "kitty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
menubar.utils.terminal = terminal 

-- Theme initialization
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/theme/theme.lua")
beautiful.icon_theme = "Papirus"

-- Layouts
require("configs.layouts")

-- Menu
require("configs.menu")

-- Wibar
local wibar = require("configs.wibar")

-- Key bindings
require("configs.keys")

-- Rules
require("configs.rules")

-- Notifications
require("configs.notifications")

-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
