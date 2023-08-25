local vicious = require("vicious")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local wififunction = function(widget)
    local wifiwidget = wibox.widget.textbox()
    vicious.register(wifiwidget, vicious.widgets.wifi, "${ssid}", 60, "enp0s3")

    local mywifi = wibox.widget {
        {
            {
                wifiwidget,
                left = 5,
                right = 5,
                top = 5,
                bottom = 5,
                widget = wibox.container.margin
            },
            bg = "#181825",
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background
        },
        widget = wibox.container.constraint
    }

    mywifi:buttons(gears.table.join(
        mywifi:buttons(),
        awful.button({}, 1, nil, function()
            awful.spawn('bash -c "rofi-wifi-menu"')
        end)
    ))

    return mywifi
end


return wififunction