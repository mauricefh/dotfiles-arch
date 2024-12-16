local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi

return function(s)
    return awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end),
        },
        forced_width  = dpi(50),
        forced_height = dpi(50),
    }
end
