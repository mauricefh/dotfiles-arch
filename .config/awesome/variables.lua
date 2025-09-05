-- variables.lua
-- Defines environment variables and global AwesomeWM configuration variables.

local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

-- Environement variable
home = os.getenv("HOME")
user = os.getenv("USER")
terminal = "wezterm" -- ghostty, wezterm
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "brave-beta"
rofi_launcher_path = home .. "/.config/rofi/scripts/launcher_t4"
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.spiral,
  awful.layout.suit.floating,
}

-- Export variables for use in other modules if needed (optional, often accessed globally in Lua)
-- For a cleaner approach, you could return a table of these, but for AwesomeWM globals are common.
-- return {
--   home = home,
--   user = user,
--   terminal = terminal,
--   editor = editor,
--   editor_cmd = editor_cmd,
--   browser = browser,
--   rofi_launcher_path = rofi_launcher_path,
--   modkey = modkey,
--   layouts = awful.layout.layouts
-- }
