--  ----------------------------------------------------------------------------
-- File:     ~/.config/awesome/rc.lua
-- Author:   Greg Fitzgerald <netzdamon@gmail.com>
-- Modified: Sat 06 Jun 2009 03:37:43 PM EDT
--  ----------------------------------------------------------------------------

-- {{{ Standard awesome library
require("awful")
require("beautiful")
require("naughty")
require("libs/shifty")
require("libs/revelation")
require("libs/config")
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

shifty.config.tags = {
    ["dev"] = { init = true, layout = awful.layout.suit.tile.bottom, position = 1, } ,
    ["www"] = { init = true, layout = awful.layout.suit.max, position = 2, } ,
    ["im"] = { init = true, layout = awful.layout.suit.tile, position = 3,  } ,
    ["mail"] = { init = true, layout = awful.layout.suit.max, position = 4, } ,
    ["irc"] = { init = true, layout = awful.layout.suit.max, position = 5, } ,
    ["music"] = { init = true, layout = awful.layout.suit.max, position = 6, } ,
    ["downloads"] = { init = true, persist = true, layout = awful.layout.suit.fair.horizontal,position = 7 } ,
    ["vbox"] = { init = true, layout = awful.layout.suit.max, position = 8, } ,
    ["media"] = { init = true, layout = awful.layout.suit.max, position = 9, } ,
}

shifty.config.apps = {
    { match = { "xterm", "XTerm", "urxvt"}, intrusive = true, honorsizehints = false, },
    { match = { "epiphany", "Firefox"                              } , tag = "www"                            } ,
    { match = { "gajim"                                          } , tag = "im",                          } ,
    { match = { "xchat"                                          } , tag = "irc",                          } ,
    { match = { "mutt", "Mutt",                                          } , tag = "mail",                          } ,
    { match = { "gmpc"}, tag = "music", },
    { match = { "gthumb", "gpodder", "gqview", "k3b", "gphoto2", "xfburn"}, tag = "media", },
    { match = { "deluge", "dta", "DTA", ".*DownThemAll!",}, tag = "downloads", },
    { match = { "VirtualBox", "VBox.*","VirtualBox.*"                               } , tag = "vbox", float = false,            } ,
    { match = { "XDosEmu", "MPlayer", "gimp", "Gnuplot", "galculator", "ristretto" } , float = true                           } ,
    { match = { "About gmpc", "Server Information", "unnamed", "About", "Dialog", "Extension", "Add-ons", "VirtualBox","glxgears",                              } , float = true,                           } ,
}

shifty.config.defaults = {
  layout = awful.layout.suit.max,
  ncol = 1,
  mwfact = 0.60,
  leave_kills = true, 
  screen = 1,
  floatBars = true,
  nopopup = true,
}

shifty.config.guess_name = true
shifty.config.guess_position = true
shifty.config.remember_index = true
shifty.config.layouts = true

-- {{{ Custom Functions
function run_once(prg)
    if not prg then
        do return nil end
    end
    os.execute("x=" .. prg .. "; pgrep -u $USERNAME -x " .. prg .. " || (" .. prg .. " &)")
end
-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. awesome.release .. " </small></b>"

-- Create a systray
if config.systray then
    mysystray = widget({ type = "systray", align = "right" })
end

--shifty.taglist = mytaglist
shifty.init()
-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
use_titlebar = false

-- }}}

-- Create a systray
if config.systray then
    mysystray = widget({ type = "systray", align = "right" })
end

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, function (tag) tag.selected = not tag.selected end),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
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
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(config.apps.terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    -- Revelation
    awful.key({ modkey }, "e", revelation.revelation ),

--[[    -- Shifty]]
    --awful.key({                   }, "XF86Back",    awful.tag.viewprev),
    --awful.key({                   }, "XF86Forward", awful.tag.viewnext),
    --awful.key({  modkey           }, "XF86Back",    shifty.shift_prev),
    --awful.key({  modkey           }, "XF86Forward", shifty.shift_next),
    --awful.key({ modkey            }, "t",           function() shifty.add({ rel_index = 1 }) end),
    --awful.key({ modkey, "Control" }, "t",           function() shifty.add({ rel_index = 1, nopopup = true }) end),
    --awful.key({ modkey            }, "r",           shifty.rename),
    --[[awful.key({ modkey            }, "w",           shifty.del),]]

    -- Application Launchers
    awful.key({ config.keys.modkey,           }, "p", function () awful.util.spawn("dmenu_run -i -b -nb '#303030' -nf '#CCCCCC' -sb '#97B26B' -sf '#000000'") end),
    awful.key({ config.keys.modkey,           }, "o", function () awful.util.spawn("/home/gregf/code/bin/clipboard/clipboard.sh") end),
    awful.key({ config.keys.modkey,           }, "g", function () awful.util.spawn("/home/gregf/code/bin/google/google.sh") end),
    awful.key({ config.keys.modkey,           }, "m", function () awful.util.spawn(config.apps.mail) end),
    awful.key({ config.keys.modkey,           }, "y", function () awful.util.spawn(config.apps.music) end),
    awful.key({ config.keys.modkey,           }, "k", function () awful.util.spawn("gvim") end),
    awful.key({ config.keys.modkey,           }, "y", function () awful.util.spawn("xlock") end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
for i=1,9 do
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey }, i,
  function ()
    local t = awful.tag.viewonly(shifty.getpos(i))
  end))
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control" }, i,
  function ()
    local t = shifty.getpos(i)
    t.selected = not t.selected
  end))
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Control", "Shift" }, i,
  function ()
    if client.focus then
      awful.client.toggletag(shifty.getpos(i))
    end
  end))
  -- move clients to other tags
  globalkeys = awful.util.table.join(globalkeys, awful.key({ modkey, "Shift" }, i,
    function ()
      if client.focus then
        local t = shifty.getpos(i)
        awful.client.movetotag(t)
        awful.tag.viewonly(t)
      end
    end))
end

-- Set keys
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys

-- }}}
-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
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
    if true then return end -- this disables the manage hook for shifty
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
    c:buttons(awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize)
    ))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] ~= nil then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] ~= nil then
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
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
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
awful.hooks.timer.register(10, function ()
    mytextbox.text = os.date(config.date_format)
end)
