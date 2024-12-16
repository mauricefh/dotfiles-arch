-- Import necessary modules
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local beautiful = require("beautiful")

gears.wallpaper.maximized("/home/curseedz/Pictures/wallpaper-1.jpg", s)

-- Initialize theme table
local theme = {}

-- Define theme properties
theme.font          = "IosevkaFixed-Regular 14"
theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_normal = "#000000"       -- Black for inactive windows
theme.border_focus  = "#00FF00"       -- Green for active windows
theme.border_marked = "#91231c"       -- Optional: color for marked windows
theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)          -- Border width

client.connect_signal("manage", function(c)
  c.shape = gears.shape.rectangle
end)

return theme
