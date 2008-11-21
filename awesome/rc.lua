-- awesome 3 configuration file
-- Greg Fitzgerald <netzdamon@gmail.com>

-- Include awesome library, with lots of useful function!
require("awful")
require("beautiful")
require("naughty")
-- Load my config settings. Most of everything you'll want to tweak is in
-- config.lua.
loadfile(awful.util.getdir("config").."/config.lua")()

-- {{{ Initialization
-- Initialize theme (colors).
--beautiful.init(config.theme)
beautiful.init(config.theme)

-- Register theme in awful.
-- This allows to not pass plenty of arguments to each function
-- to inform it about colors we want it to draw.
--awful.beautiful.register(beautiful)
-- }}}

-- {{{ Tags
-- Define tags table.
tags_names	= { "dev", "www", "im", "news", "music", "mail", "irc", "media", "misc" }
tags_layout	= { "tiletop", "max", "fairv", "max", "max", "max", "tiletop", "tiletop", "tiletop" } 
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
     for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag({ name = tags_names[tagnumber], layout = tags_layout[tagnumber] })
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", config.apps.terminal .. " -e man awesome" },
   { "edit config", config.apps.editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", config.apps.terminal }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

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
mytasklist.buttons = { button({ }, 1, function (c) client.focus = c; c:raise() end),
                       button({ }, 3, function () awful.menu.clients({ width=250 }) end),
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
awesome.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}
-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    
    -- Use F1-F9 for desktops instead of 1-9
    hotkey = "F"..i
    keybinding({ config.keys.modkey }, hotkey,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ config.keys.modkey, config.keys.control }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ config.keys.modkey, config.keys.shift }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ config.keys.modkey, config.keys.control, config.keys.shift }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ config.keys.modkey }, "Left", awful.tag.viewprev):add()
keybinding({ config.keys.modkey }, "Right", awful.tag.viewnext):add()
keybinding({ config.keys.modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ config.keys.modkey }, "Return", function () awful.util.spawn(config.apps.terminal) end):add()

-- added by gregf
keybinding({ config.keys.modkey }, "p", function() awful.util.spawn("dmenu_run -i -b -nb '#303030' -nf '#CCCCCC' -sb '#97B26B' -sf '#000000'") end):add()
keybinding({ config.keys.modkey }, "o", function() awful.util.spawn("exec /home/gregf/code/bin/clipboard/clipboard.sh") end):add()
keybinding({ config.keys.modkey }, "n", function() awful.util.spawn(config.apps.screen) end):add()
keybinding({ config.keys.modkey }, "g", function() awful.util.spawn("exec /home/gregf/code/bin/google/google.sh") end):add()
-- Application Launchers
keybinding({ config.keys.super }, "m", function() awful.util.spawn(config.apps.mail) end):add()
keybinding({ config.keys.super }, "l", function() awful.util.spawn(config.apps.rss) end):add()
keybinding({ config.keys.super }, "f", function() awful.util.spawn(config.apps.browser) end):add()
keybinding({ config.keys.super }, "h", function() awful.util.spawn(config.apps.terminal.." -T htop -e htop") end):add()
keybinding({ config.keys.super }, "p", function() awful.util.spawn(config.apps.music) end):add()
keybinding({ config.keys.super }, "k", function() awful.util.spawn("gvim") end):add()
keybinding({ config.keys.super }, "t", function() awful.titlebar.add(client.focus) end):add()
keybinding({ config.keys.super, config.keys.shift }, "t", function() awful.titlebar.remove(client.focus) end):add()

-- restart / quit
keybinding({ config.keys.modkey, config.keys.control }, "r", awesome.restart):add()
keybinding({ config.keys.modkey, config.keys.shift }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ config.keys.modkey }, "m", awful.client.maximize):add()
keybinding({ config.keys.modkey }, "c", function () client.focus:kill() end):add()
keybinding({ config.keys.modkey }, "j", function () awful.client.focus.byidx(1); client.focus:raise() end):add()
keybinding({ config.keys.modkey }, "k", function () awful.client.focus.byidx(-1);  client.focus:raise() end):add()
keybinding({ config.keys.modkey, config.keys.shift }, "j", function () awful.client.swap(1) end):add()
keybinding({ config.keys.modkey, config.keys.shift }, "k", function () awful.client.swap(-1) end):add()
keybinding({ config.keys.modkey, config.keys.control }, "j", function () awful.screen.focus(1) end):add()
keybinding({ config.keys.modkey, config.keys.control }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ config.keys.modkey, config.keys.control }, "space", awful.client.togglefloating):add()
keybinding({ config.keys.modkey, config.keys.control }, "Return", function () client.focus:swap(awful.client.master()) end):add()
--keybinding({ config.keys.modkey }, "o", awful.client.movetoscreen):add()
keybinding({ config.keys.modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ config.keys.modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ config.keys.modkey, config.keys.shift }, "r", function () client.focus:redraw() end):add()

-- Layout manipulation
keybinding({ config.keys.modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ config.keys.modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ config.keys.modkey, config.keys.shift }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ config.keys.modkey, config.keys.shift }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ config.keys.modkey, config.keys.control }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ config.keys.modkey, config.keys.control }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ config.keys.modkey }, "space", function () awful.layout.inc(config.layouts, 1) end):add()
keybinding({ config.keys.modkey, config.keys.shift }, "space", function () awful.layout.inc(config.layouts, -1) end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ config.keys.modkey }, "t", awful.client.togglemarked):add()

for i = 1, keynumber do
    keybinding({ config.keys.modkey, config.keys.shift }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end
-- }}}

-- {{{ Custom functions
-- none just yet
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
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)
-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c)
    if config.titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { config.keys.modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ config.keys.modkey }, 1, function (c) c:mouse_move() end),
        button({ config.keys.modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c
    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    local role = c.role
    local name = c.name
    
    if config.float[cls] then
        c.floating = config.float[cls]
    elseif config.float[name] then
        c.floating = config.float[name]
    elseif config.float[inst] then
        c.floating = config.float[inst]
    elseif config.float[role] then
        c.floating = config.float[role]
    end

    -- Check application->screen/tag mappings.
    local target
    for i,t in ipairs(config.maps) do
        if t.apps then
            for k,w in pairs(t.apps) do
                local unmatched = nil
                    if name and name:find(w) then awful.client.movetotag(tags[t.screen][t.name], c)
                    elseif role and role:find(w) then awful.client.movetotag(tags[t.screen][t.name], c)
                    elseif inst and inst:find(w) then awful.client.movetotag(tags[t.screen][t.name], c)
                    elseif cls and cls:find(w) then awful.client.movetotag(tags[t.screen][t.name], c)
                    else unmatched = true
                end
            end
        end
    end

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints
    c.honorsizehints = false
    if config.honorsizehints then
        c.honorsizehints = true
    end

    client.focus = c
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.get(screen)
    if layout then
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

    -- Uncomment if you want mouse warping
    --[[
    if client.focus then
        local c_c = client.focus:fullgeometry()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end)

-- Hook called every second
awful.hooks.timer.register(1, function ()
    if config.time_t then
        -- For unix time_t lovers
        mytextbox.text = " " .. os.time() .. " "
        -- Otherwise use:
    else
        mytextbox.text = " " .. os.date(config.date_format) .. " "
    end
end)
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
