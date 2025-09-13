-- rules.lua
-- Defines rules to apply to new clients.

local awful = require("awful")
local beautiful = require("beautiful")

awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },

  -- {
  --   rule = { class = "slack" },
  --   properties = {
  --     focus = false, -- Prevent Slack windows from gaining focus
  --     raise = false, -- Prevent Slack windows from being raised
  --   }
  -- },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "yazi", "lazygit"
      },
      name = {
        "Event Tester",    -- xev.
      },
      role = {
        "AlarmWindow",     -- Thunderbird's calendar.
        "ConfigManager",   -- Thunderbird's about:config.
        "pop-up",          -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },

}
