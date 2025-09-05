-- mousebindings.lua
-- Defines mouse bindings for root window and clients.

local awful = require("awful")
local gears = require("gears")

-- Root mouse bindings
root_buttons = gears.table.join( -- Renamed from mymainmenu:toggle() to avoid issues if mymainmenu isn't defined yet
  awful.button({}, 3, function() awful.menu.main_menu():toggle() end), -- Assuming a default main menu if mymainmenu isn't global
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
)

-- Client mouse bindings
clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)
