local gears = require("gears")
local awful = require("awful")

-- Create an imagebox widget which will contain an icon indicating which layout we're using.
-- We need one layoutbox per screen.
s.mylayoutbox = awful.widget.layoutbox(s)
s.mylayoutbox:buttons(gears.table.join(
                        awful.button({ }, 1, function () awful.layout.inc( 1) end),
                        awful.button({ }, 3, function () awful.layout.inc(-1) end),
                        awful.button({ }, 4, function () awful.layout.inc( 1) end),
                        awful.button({ }, 5, function () awful.layout.inc(-1) end)))
-- Create a taglist widget
s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
}

-- Create the wibox
s.mywibox = awful.wibar({ position = "top", screen = s })

-- Add widgets to the wibox
s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        s.mytaglist,
    },
    { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        mykeyboardlayout,
        wibox.widget.systray(),
        mytextclock,
        s.mylayoutbox,
    },