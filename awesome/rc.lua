--  ----------------------------------------------------------------------------
-- File:     ~/.config/awesome/rc.lua
-- Author:   Greg Fitzgerald <netzdamon@gmail.com>
-- Modified: Sun 29 Mar 2009 08:24:25 PM EDT
--  ----------------------------------------------------------------------------

-- {{{ Standard awesome library
require("awful")
require("beautiful")
require("libs/naughty")
require("libs/config")
require("libs/revelation")
-- }}}

beautiful.init(config.theme)
modkey = config.keys.modkey

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile, --1
    awful.layout.suit.tile.left, --2
    awful.layout.suit.tile.bottom, --3
    awful.layout.suit.tile.top, --4
    awful.layout.suit.fair, --5
    awful.layout.suit.fair.horizontal, --6
    awful.layout.suit.max, --7
    awful.layout.suit.max.fullscreen, --8
    awful.layout.suit.magnifier, --9
    awful.layout.suit.floating --10
}
-- }}}
-- Table of clients that should be set floating.
floatapps =
{
    ["gimp"] = true,
    ["Saved Passwords"] = true,
    ["Cookies"] = true,
    ["Browser"] = true,
    ["Downloads"] = true,
    ["Download"] = true,
    ["Library"] = true,
    ["Places"] = true,
    ["Greasemonkey"] = true,
    ["MPlayer"] = true,
    ["Evince"] = true,
    ["Xmessage"] = true,
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Firefox"] = { screen = 1, tag = 2 },
    ["Xchat"] = { screen = 1, tag = 5 },
    ["mutt"] = { screen = 1, tag = 4 },
    ["gPodder"] = { screen = 1, tag = 9 },
    ["Gmpc"] = { screen = 1, tag = 6 },
    ["K3b"] = { screen = 1, tag = 9 },
    ["DTA"] = { screen = 1, tag = 7 },
    ["Gajim.py"] = { screen = 1, tag = 3 },
    ["Deluge"] = { screen = 1, tag = 7 },
    ["Gimp"] = { screen = 1, tag = 9 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- }}}
-------------------------------------------------------------------------------------
-- {{{ Tags

tag_properties = { { name = "dev"
                   , layout = layouts[4]
                   }
                 , { name = "www"
                   , layout = layouts[4]
                   }
                 , { name = "im"
                   , layout = layouts[1]
                   }
                 , { name = "mail"
                   , layout = layouts[1]
                   }
                 , { name = "irc"
                   , layout = layouts[3]
                   }
                 , { name = "music"
                   , layout = layouts[7]
                   }
                 , { name = "downloads"
                   , layout = layouts[3]
                   }
                 , { name = "vbox"
                   , layout = layouts[7]
                   }
                 , { name = "media"
                   , layout = layouts[3]
                   }
                 }

-- Define tags table.
tags = {}
for s = 1, screen.count() do
    tags[s] = { }
    for i, v in ipairs(tag_properties) do
        tags[s][i] = tag(v.name)
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", v.layout)
        awful.tag.setproperty(tags[s][i], "mwfact", v.mwfact)
        awful.tag.setproperty(tags[s][i], "nmaster", v.nmaster)
        awful.tag.setproperty(tags[s][i], "ncols", v.ncols)
    end
    tags[s][1].selected = true
end

-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

-- Create a systray
if config.systray then
    mysystray = widget({ type = "systray", align = "right" })
end

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ config.keys.modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ config.keys.modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c)
                                          if not c:isvisible() then
                                              awful.tag.viewonly(c:tags()[1])
                                          end
                                          client.focus = c
                                      end),
                       button({ }, 3, function () if instance then instance:hide() end instance = awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function () awful.client.focus.byidx(1) end),
                       button({ }, 5, function () awful.client.focus.byidx(-1) end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s],
                           mytextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings
globalkeys =
{
    key({ config.keys.modkey,           }, "Left",   awful.tag.viewprev       ),
    key({ config.keys.modkey,           }, "Right",  awful.tag.viewnext       ),
    key({ config.keys.modkey,           }, "Escape", awful.tag.history.restore),

    key({ config.keys.modkey,           }, "j", function () awful.client.focus.byidx( 1) end),
    key({ config.keys.modkey,           }, "k", function () awful.client.focus.byidx(-1) end),

    -- Layout manipulation
    key({ config.keys.modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    key({ config.keys.modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    key({ config.keys.modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    key({ config.keys.modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    key({ config.keys.modkey,           }, "u", awful.client.urgent.jumpto),
    key({ config.keys.modkey,           }, "Tab", function () awful.client.focus.history.previous() end),

    -- Standard program
    key({ config.keys.modkey,           }, "Return", function () awful.util.spawn(config.apps.terminal) end),
    key({ config.keys.modkey, "Control" }, "r", awesome.restart),
    key({ config.keys.modkey, "Shift"   }, "q", awesome.quit),

    key({ config.keys.modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    key({ config.keys.modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    key({ config.keys.modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    key({ config.keys.modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    key({ config.keys.modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    key({ config.keys.modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    key({ config.keys.modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ config.keys.modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Application Launchers
    key({ config.keys.modkey,           }, "p", function () awful.util.spawn("dmenu_run -i -b -nb '#303030' -nf '#CCCCCC' -sb '#97B26B' -sf '#000000'") end),
    key({ config.keys.modkey,           }, "o", function () awful.util.spawn("/home/gregf/code/bin/clipboard/clipboard.sh") end),
    key({ config.keys.modkey,           }, "g", function () awful.util.spawn("/home/gregf/code/bin/google/google.sh") end),
    key({ config.keys.modkey,           }, "m", function () awful.util.spawn(config.apps.mail) end),
    key({ config.keys.modkey,           }, "y", function () awful.util.spawn(config.apps.music) end),
    key({ config.keys.modkey,           }, "k", function () awful.util.spawn("gvim") end),
    key({ config.keys.modkey,           }, "y", function () awful.util.spawn("xlock") end),
    key({ config.keys.modkey,           }, "e", revelation.revelation ),

}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    key({ config.keys.modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ config.keys.modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    key({ config.keys.modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    key({ config.keys.modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ config.keys.modkey,           }, "o",      awful.client.movetoscreen                        ),
    key({ config.keys.modkey,           }, "r",      function (c) c:redraw()                       end),
    key({ config.keys.modkey }, "t", awful.client.togglemarked),
    key({ config.keys.modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
}

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys,
        key({ config.keys.modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ config.keys.modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ config.keys.modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ config.keys.modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end


for i = 1, keynumber do
    table.insert(globalkeys, key({ config.keys.modkey, "Shift" }, "F" .. i,
                 function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks

-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
        c.opacity = 1
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
        c.opacity = 0.6
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c
    
    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    --awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    c.size_hints_honor = false
end)
-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute
awful.hooks.timer.register(1, function ()
    mytextbox.text = os.date(config.date_format)
end)
-- }}}
