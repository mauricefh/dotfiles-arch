local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

return function(s)
    return awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,  -- Ensure you define tasklist_buttons
        layout   = {
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = dpi(30),
                    thickness     = 1,
                    color         = '#777777',
                    widget        = wibox.widget.separator,
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = dpi(5),
            layout  = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                id     = 'background_role',
                widget = wibox.container.background,
            },
            {
                {
                    id            = 'clienticon',
                    widget        = awful.widget.clienticon,
                    forced_width  = dpi(50),
                    forced_height = dpi(50),
                },
                margins = dpi(5),
                widget  = wibox.container.margin,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        create_callback = function(self, c, index, objects)
            self:get_children_by_id('clienticon')[1].client = c
        end,
    }
end
