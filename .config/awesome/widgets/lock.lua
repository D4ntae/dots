local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local lockbar = function(widget)


    local powerbutton = wibox.widget {
        wibox.widget {
            image = "/home/dantae/.config/awesome/icons/lockbar/powerbutton.png",
            resize = true,
            widget = wibox.widget.imagebox
        },
        left = 7,
        right = 7,
        top = 7,
        bottom = 7,
        widget = wibox.container.margin
    }

    powerbutton:buttons(gears.table.join(
        powerbutton:buttons(),
        awful.button({}, 1, nil, function()
            awful.spawn('bash -c "poweroff"')
        end)
    ))

    local lockbutton = wibox.widget {
        wibox.widget {
            image = "/home/dantae/.config/awesome/icons/lockbar/lock.png",
            resize = true,
            widget = wibox.widget.imagebox
        },
        left = 7,
        right = 7,
        top = 7,
        bottom = 7,
        widget = wibox.container.margin
    }

    lockbutton:buttons(gears.table.join(
        lockbutton:buttons(),
        awful.button({}, 1, nil, function()
            awful.spawn('bash -c "dm-tool lock"')
        end)
    ))

    local bar = wibox.widget {
        lockbutton,
        powerbutton,
        layout = wibox.layout.fixed.horizontal
    }
    local mybar = wibox.widget {
        {
            bar,
            bg = "#181825",
            shape = function (cr, w, h)
                gears.shape.rounded_rect(cr, w, h, 7)
            end,
            widget = wibox.container.background
        },
        widget = wibox.container.constraint
    }

    return mybar    
end

return lockbar