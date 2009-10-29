--  ----------------------------------------------------------------------------
-- File:     ~/.config/awesome/rc.lua
-- Author:   Greg Fitzgerald <netzdamon@gmail.com>
-- Modified: Sat 24 Oct 2009 1:39:10 PM EDT
--  ----------------------------------------------------------------------------

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Config Settings
require("lib/config")
require("lib/shifty")

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
beautiful.init(config.theme)
modkey = config.keys.modkey

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
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
    { match = { "epiphany", "Navigator", "navigator"                              } , tag = "www"                            } ,
    { match = { "gajim"                                          } , tag = "im",                          } ,
    { match = { "xchat"                                          } , tag = "irc",                          } ,
    { match = { "mutt", "Mutt",                                          } , tag = "mail",                          } ,
    { match = { "gmpc"}, tag = "music", },
    { match = { "gthumb", "gpodder", "gqview", "k3b", "gphoto2", "xfburn"}, tag = "media", },
    { match = { "deluge", "dta", "DTA", ".*DownThemAll!",}, tag = "downloads", },
    { match = { "VirtualBox", "VBox.*","VirtualBox.*"                               } , tag = "vbox", float = false,            } ,
    { match = { "XDosEmu", "MPlayer", "gimp", "Gnuplot", "galculator", "ristretto", "xfce4-mixer", "Xfce4-mixer" } , float = true  } ,
    { match = { "About gmpc", "Server Information", "unnamed", "About", "Dialog", "Extension", "Add-ons", "VirtualBox","glxgears",                              } , float = true,                           } ,
}

shifty.config.defaults = {
  layout = awful.layout.suit.max,
  ncol = 1,
  mwfact = 0.60,
  leave_kills = true, 
  screen = 1,
  nopopup = true,
}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, config.date_format, 30 )

-- Create a systray
mysystray = widget({ type = "systray" })

shifty.taglist = mytaglist
shifty.init()
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
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
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
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
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
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
    -- Shifty
    awful.key({                   }, "XF86Back",    awful.tag.viewprev),
    awful.key({                   }, "XF86Forward", awful.tag.viewnext),
    awful.key({  modkey           }, "XF86Back",    shifty.shift_prev),
    awful.key({  modkey           }, "XF86Forward", shifty.shift_next),
    --awful.key({ modkey            }, "t",           function() shifty.add({ rel_index = 1 }) end),
    --awful.key({ modkey, "Control" }, "t",           function() shifty.add({ rel_index = 1, nopopup = true }) end),
    awful.key({ modkey            }, "r",           shifty.rename),
    awful.key({ modkey            }, "w",           shifty.del),
    -- Application Launchers
    awful.key({ modkey,           }, "n", function () awful.util.spawn(config.apps.tmux) end),
    awful.key({ modkey,           }, "p", function () awful.util.spawn(config.apps.launcher) end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("/home/gregf/code/bin/gentoobugs/gentoobugs.rb") end),
    awful.key({ modkey,           }, "o", function () awful.util.spawn("/home/gregf/code/bin/clipboard/clipboard.sh") end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("/home/gregf/code/bin/google/google.sh") end),
    awful.key({ modkey,           }, "m", function () awful.util.spawn(config.apps.mail) end),
    awful.key({ modkey,           }, "t", function () awful.util.spawn(config.apps.filemanager) end),
    awful.key({ modkey,           }, "i", function () awful.util.spawn(config.apps.irc) end),
    awful.key({ modkey,           }, "f", function () awful.util.spawn(config.apps.browser) end),
    awful.key({ modkey,           }, "h", function () awful.util.spawn("huludesktop") end),
    awful.key({ modkey,           }, "y", function () awful.util.spawn(config.apps.music) end),
    --awful.key({ modkey,           }, "j", function () awful.util.spawn(config.apps.chat) end),
    awful.key({ modkey,           }, "k", function () awful.util.spawn(config.apps.graphical_editor) end),
    awful.key({ modkey,           }, "y", function () awful.util.spawn(config.apps.lock) end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
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

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
shifty.config.globalkeys = globalkeys
shifty.config.clientkeys = clientkeys

-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    --{ rule = { class = "pinentry" },
    --  properties = { floating = true } },
    --{ rule = { class = "gimp" },
    --  properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
--    { rule = { class = "Firefox" },
--       properties = { tag = tags[1][2] } },
--    { rule = { class = "Gajim.py" },
--       properties = { tag = tags[1][3] } },
--    { rule = { class = "Gmpc" },
--       properties = { tag = tags[1][5] } },
}
-- }}}

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
