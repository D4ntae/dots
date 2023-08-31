local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local weatherfunction = function()
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
    local myweather = wibox.widget {
        {
            {
		brightness_widget {
			type = "icon_and_text",
			program = "light",
			base = "40",
			tooltip = true,
			percentage = true,
			rmb_set_max = true
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
    return myweather
end

return weatherfunction
