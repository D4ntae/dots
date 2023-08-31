local vicious = require("vicious")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local wififunction = function(widget)
    local wifiwidget = wibox.widget.textbox()
    vicious.register(wifiwidget, vicious.widgets.wifi, " ${ssid}", 60, "wlp0s20f3")


    local wifiicon = wibox.widget {
        wibox.widget {
            image = "/home/dantae/.config/awesome/icons/wifi/image.png",
            resize = true,
            widget = wibox.widget.imagebox
        },
        left = 1,
        right = 1,
        top = 1,
        bottom = 1,
        widget = wibox.container.margin
    }

    local mywifi = wibox.widget {
        {
            {
                {
                    layout = wibox.layout.fixed.horizontal,
                    wifiicon,
                    wifiwidget,
                },
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
            awful.spawn('xdotool mousemove 1551 22 click 1', false)
        end)
    ))

    return mywifi
end


return wififunction
