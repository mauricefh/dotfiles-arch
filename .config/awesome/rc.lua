-- rc.lua
-- This file is the main entry point for your AwesomeWM configuration.
-- It loads other modules to keep the configuration organized.

pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
require("awful.hotkeys_popup.keys")

-- Load configuration modules
require("variables")
require("theme") -- Assuming theme.lua exists and handles beautiful.init
require("wibar")
require("keybindings")
require("mousebindings")
require("rules")
require("signals")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- Set root key and mouse bindings
root.keys(globalkeys)
root.buttons(root_buttons) -- Renamed to avoid confusion with clientbuttons

-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
