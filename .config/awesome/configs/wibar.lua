local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local mytasklist = require("widgets.mytasklist")
local mytaglist = require("widgets.mytaglist")
local mylayoutbox = require("widgets.mylayoutbox")
local dpi = require("beautiful.xresources").apply_dpi
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local deficient = require("deficient")

local battery_widget = deficient.battery_widget {
    battery_prefix = "",
    widget_text = "${AC_BAT}${color_on}${percent}%${color_off}",
    widget_font = "IosevkaFixed 14",
}

local brightness_ctrl = deficient.brightness {
    -- pass options here
}

 awful.screen.connect_for_each_screen(function(s)
     -- Wallpaper
     -- require("configs.wallpaper")(s)

     -- Each screen has its own tag table.
     awful.tag({ "Main", "Browser", "Chat/Email", "Files", "5", "6", "7", "Media", "Misc" }, s, awful.layout.layouts[1])

     -- Create a promptbox for each screen
     s.mypromptbox = awful.widget.prompt()

     -- Create widgets
     s.mylayoutbox = mylayoutbox(s)
     s.mytaglist = mytaglist(s)
     s.mytasklist = mytasklist(s)

     -- Create the wibar
     -- s.mywibox = awful.wibar {
     --     position = "bottom",
     --     screen   = s,
     --     height   = dpi(32),
     --     widget   = {
     --         layout = wibox.layout.align.horizontal,
     --         { -- Left widgets
     --             layout = wibox.layout.fixed.horizontal,
     --             mylauncher,
     --             s.mytaglist,
     --             s.mypromptbox,
     --         },
     --         s.mytasklist, -- Middle widget
     --         { -- Right widgets
     --             layout = wibox.layout.fixed.horizontal,
     --             battery_widget,
     --             brightness_ctrl,
     --             wibox.widget.systray(),
     --             mytextclock,
     --             s.mylayoutbox,
     --         },
     --     }
     -- }
 end)
