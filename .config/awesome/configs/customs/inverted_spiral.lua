local awful = require("awful")
local math = require("math")

-- Inverted Spiral Layout
local spiral_layout = {}

function spiral_layout.arrange(p)
    local clients = p.clients
    local t = p.tag
    local screen = p.screen
    local w = p.workarea.width
    local h = p.workarea.height

    if #clients == 0 then return end

    -- Set the starting positions and sizes for the spiral
    local angle = math.pi / 4  -- initial angle of 45 degrees
    local radius = 0  -- starting radius
    local width_factor = w / 6  -- adjust the width scaling factor
    local height_factor = h / 6  -- adjust the height scaling factor
    local window_padding = 10  -- padding between windows

    -- Loop over each client to position it in the spiral pattern
    for i, c in ipairs(clients) do
        -- Calculate new position and size for each client
        local x = p.workarea.x + radius * math.cos(angle) - c.width / 2
        local y = p.workarea.y + radius * math.sin(angle) - c.height / 2
        local w = width_factor * (i / #clients)
        local h = height_factor * (i / #clients)

        -- Apply the calculated position and size to the window
        c:geometry({ x = x, y = y, width = w, height = h })

        -- Increment the radius and angle to simulate a spiral
        radius = radius + window_padding
        angle = angle + math.pi / 6  -- this controls the density of the spiral
    end
end

-- Register the layout
awful.layout.layouts = awful.layout.layouts or {}
table.insert(awful.layout.layouts, spiral_layout)

