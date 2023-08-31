-- Iu LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")

local vicious = require("vicious")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local cairo = require("lgi").cairo
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require("widgets.exit_screen")

-- Error handling file
require("main.error_handling")

-- User vars file (term, wallpaper...)
local user_vars = require("main.user_vars")

-- Autostart setup
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/dantae/.config/awesome/themes/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = user_vars.term
editor = user_vars.editor
editor_cmd = terminal .. " -e " .. editor

modkey = user_vars.modkey

-- Local layouts file
awful.layout.layouts = require("main.layouts")

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock('<span color="#ffffff" font="JetBrainsMono Nerd Font 10"> %b %e, %H:%M </span>', 5)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local wallpaper = require("design.wallpaper")


awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    create_exit_screen(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    

    local function update_taglist(widget, tag, _, _)
        if tag == s.selected_tag then
        -- color for currently active tag
        widget:get_children_by_id("circle")[1].bg = "#74c7ec"
        else
        -- this can also be s.clients if you only want visible client included
        for _, c in ipairs(s.all_clients) do
            for _, t in ipairs(c:tags()) do
            if tag == t then
                -- color for other tags with at least one client
                widget:get_children_by_id("circle")[1].bg = "#585b70"
                return
            end
            end
        end
        -- color for other tags with no clients
        widget:get_children_by_id("circle")[1].bg = "#11111b"
        end
    end
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        bg = "#1e1e2e",
        widget_template = {
            {
                {
                    {
                        id = "index_role",
                        widget = wibox.widget.textbox,
                    },
                    id = "circle",
                    shape = gears.shape.circle,
                    bg = "#11111b",
                    shape_border_color = "#cdd6f4",
                    shape_border_width = 1,
                    forced_width = 15,
                    forced_heigth = 15,
                    widget = wibox.container.background,
                },
                margins = 4,
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            create_callback = update_taglist,
            update_callback = update_taglist
        },
        buttons = taglist_buttons
    }

    -- Wrapper for taglist that adds the background and other effects
    local taglist_background = {
        {
            {
                s.mytaglist,
                left = 6,
                right = 6,
                top = 2,
                bottom = 2,
                widget = wibox.container.margin
            },
            bg = "#181825",
            shape = function (cr, w, h)
                gears.shape.rounded_rect(cr, w, h, 7)
            end,
            widget = wibox.container.background
        },
        widget = wibox.container.constraint
    }
    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "top", 
        screen = s, 
        bg = "#18182500", 
        height = 35, 
        margins = 10
    }
    
    local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
    local myvolume = {
        {
            {
                volume_widget {
                    widget_type = 'horizontal_bar', 
                    margins = 10, 
                    with_icon = true,
                    main_color = "#a6e3a1",
                    mute_color = "#eba0ac",
                    width = 50
                },
                left = 10,
                right = 10,
                top = 2,
                bottom = 2,
                widget = wibox.container.margin
            },
            bg = "#181825",
            shape = function (cr, w, h)
                gears.shape.rounded_rect(cr, w, h, 7)
            end,
            widget = wibox.container.background
        },
        widget = wibox.container.constraint
    }
    local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
    local mybattery = {
        {
            {
                battery_widget {
                    show_current_level=true,
                    display_notification=true,
                    path_to_icons = "/home/dantae/.config/awesome/icons/battery/"
                },
                left = 10,
                right = 10,
                top = 2,
                bottom = 2,
                widget = wibox.container.margin
            },
            bg = "#181825",
            shape = function (cr, w, h)
                gears.shape.rounded_rect(cr, w, h, 7)
            end,
            widget = wibox.container.background
        },
        widget = wibox.container.constraint
    }


    -- Calendar widget
    local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
    local mycalendar = calendar_widget {
        theme = 'nord',
        placement = "top_left",
        start_sunday = false,
        radius = 5,
        previous_month_button = 5,
        next_month_button = 4
    }
    mytextclock:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then mycalendar.toggle() end
    end)


    local mysystray = {
        {
            {
                wibox.widget.systray {
                    spacing = 5,
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

    -- WIFI widget
    local wifiwidget = require("widgets.wifi")
    -- Lockbar widget
    local mylockbar = require("widgets.lock")

    -- Weather widget
    local myweather = require("widgets.weather")

    -- Brightness widget
    local mybright = require("widgets.brightness")
    -- Add widgets to the wibox
    local textclockwidget = {
        {
            {
                mytextclock,
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
    s.mywibox:setup {
        {
            { -- Left widgets
                widget = wibox.container.place,
                fill_vertical = true,
                content_fill_vertical = true,
                halign = "left",
                {
                    textclockwidget,
                    myweather(),
                    spacing = 5,
                    layout = wibox.layout.fixed.horizontal
                }
            },
            {
                taglist_background,
                valign = "top",
                content_fill_vertical = true,
                widget = wibox.container.place,
            },
            { -- Right widgets
                {
                    mykeyboardlayout,
                    mysystray,
                    wifiwidget(),
                    mybright(),
                    myvolume,
                    mybattery,
                    mylockbar(),
                    spacing  = 5,
                    layout = wibox.layout.fixed.horizontal
                },
                valign = "top",
                halign = "right",
                widget = wibox.container.place,

            },
            layout = wibox.layout.flex.horizontal,
        },
        top = 7,
        bottom = 0,
        left = 6,
        right = 6,
        widget = wibox.container.margin
    }


    

end)
-- }}}

-- {{{ Key bindings
globalkeys = require("bindings.globalkeys")

clientkeys = require("bindings.clientkeys")

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = require("bindings.clientbuttons")

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = require("main.rules")
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 15, bg_normal = "#11111b", bg_focus = "#11111b", fg_normal = "#cdd6f4", fg_focus = "#cdd6f4"}) : setup {
        { -- Left
            {
                awful.titlebar.widget.iconwidget(c),
                left = 2,
                right = 2,
                bottom = 2,
                top = 2,
                widget = wibox.container.margin
            },
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            {
                awful.titlebar.widget.maximizedbutton(c),
                left = 2,
                right = 2,
                bottom = 2,
                top = 2,
                widget = wibox.container.margin
            },
            {
                awful.titlebar.widget.closebutton(c),
                left = 2,
                right = 2,
                bottom = 2,
                top = 2,
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal()
        },
        height = 10,
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
