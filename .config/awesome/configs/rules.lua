local awful = require("awful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    }
    -- Browser
    ruled.client.append_rule {
        rule = { instance = "chromium" },
        properties = { tag = "Browser" }
    }
    -- Chat/Email
    ruled.client.append_rule {
        rule = { instance = "discord" },
        properties = { tag = "Chat/Email" }
    }
    ruled.client.append_rule {
        rule = { instance = "teams-for-linux" },
        properties = { tag = "Chat/Email" }
    }
    ruled.client.append_rule {
        rule = { instance = "org.gnome.Evolution" },
        properties = { tag = "Chat/Email" }
    }
    -- Files
    ruled.client.append_rule {
        rule = { instance = "thunar" },
        properties = { tag = "Files" }
    }
    -- 5
    -- 6
    -- 7 
    -- Media
    ruled.client.append_rule {
        rule = { instance = "spotify" },
        properties = { tag = "Media" }
    }  
    -- Misc

end)
