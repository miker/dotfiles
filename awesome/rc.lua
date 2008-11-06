-- awesome 3 configuration file
-- Greg Fitzgerald <netzdamon@gmail.com>

-- Include awesome library, with lots of useful function!
require("awful")
require("tabulous")
require("beautiful")

 
-- {{{ Config settings 
config = {}
config.home = "/home/gregf/"
config.theme_name = "gregf"
config.theme_path = config.home..".awesome/themes/"
config.theme = config.theme_path..config.theme_name

config.terminal = "xterm"

config.modkey = "Mod1"
config.superkey = "Mod4"

-- tag bindings
xterm = 1
internet = 2
jabber = 3
news = 4
music = 5
mail = 6
irc = 7
vbox = 8
burning = 9

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    "tile",
    "tileleft",
    "tilebottom",
    "tiletop",
    "fairh",
    "fairv",
    --"magnifier",
    "max",
    --"spiral",
    --"dwindle",
    "floating"
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a config.terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["gajim.py"] = true
}

config.float = {}
config.float = {
    { app = "MPlayer", true },
    { app = "gimp", true },
    { app = "gajim.py", true }
}

-- possible add tagnumber and layout into this?
config.tags = {}
config.tags = {
    { name = music, screen = 1, apps = {"gmpc"}, },
    { name = internet, screen = 1, apps = {".*Firefox"} },
    { name = vbox, screen = 1, apps = {"Toplevel", "DTA"} },
    { name = irc, screen = 1, apps = {"xchat"} },
    { name = jabber, screen = 1, apps = { "gajim.*"} },
    { name = news, screen = 1, apps = {"liferea"} },
    { name = burning, screen = 1, apps = {"k3b"} },
    { name = mail, screen = 1, apps = {"mutt"} }
}

-- Define if we want to use titlebar on all applications.
config.titlebar = true
-- }}}

config.systray = false 

-- set time_t to true if you would rather use that over date_format
config.time_t = false 
config.date_format = "%A %B %d %I:%M:%S%P"

config.iconbox = false 
config.honorsizehints = false 
-- {{{ Initialization
-- Initialize theme (colors).
beautiful.init(config.theme)

-- Register theme in awful.
-- This allows to not pass plenty of arguments to each function
-- to inform it about colors we want it to draw.
awful.beautiful.register(beautiful)

-- Uncomment this to activate autotabbing
tabulous.autotab_start()
-- }}}

-- {{{ Tags
-- Define tags table.
tags_names	= { "xterm", "internet", "jabber", "news", "music", "mail", "irc", "vbox", "burning" }
tags_layout	= { "tile", "max", "floating", "max", "max", "max", "tile", "tile", "tile" } 
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

-- {{{ Statusbar
-- Create a taglist widget
mytaglist = widget({ type = "taglist", name = "mytaglist" })
mytaglist:mouse_add(mouse({}, 1, function (object, tag) awful.tag.viewonly(tag) end))
mytaglist:mouse_add(mouse({ config.modkey }, 1, function (object, tag) awful.client.movetotag(tag) end))
mytaglist:mouse_add(mouse({}, 3, function (object, tag) tag.selected = not tag.selected end))
mytaglist:mouse_add(mouse({ config.modkey }, 3, function (object, tag) awful.client.toggletag(tag) end))
mytaglist:mouse_add(mouse({ }, 4, awful.tag.viewnext))
mytaglist:mouse_add(mouse({ }, 5, awful.tag.viewprev))
mytaglist.label = awful.widget.taglist.label.all

-- Create a tasklist widget
mytasklist = widget({ type = "tasklist", name = "mytasklist" })
mytasklist:mouse_add(mouse({ }, 1, function (object, c) client.focus = c; c:raise() end))
mytasklist:mouse_add(mouse({ }, 4, function () awful.client.focusbyidx(1) end))
mytasklist:mouse_add(mouse({ }, 5, function () awful.client.focusbyidx(-1) end))
mytasklist.label = awful.widget.tasklist.label.currenttags

-- Create a textbox widget
mytextbox = widget({ type = "textbox", name = "mytextbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> awesome " .. AWESOME_VERSION .. " </small></b>"
mypromptbox = widget({ type = "textbox", name = "mypromptbox", align = "left" })

-- Create an iconbox widget
if config.iconbox then
    myiconbox = widget({ type = "textbox", name = "myiconbox", align = "left" })
    myiconbox.text = "<bg image=\"/usr/share/awesome/icons/awesome16.png\" resize=\"true\"/>"
end

-- Create a systray
if config.systray then
    mysystray = widget({ type = "systray", name = "mysystray", align = "right" })
end

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget({ type = "textbox", name = "mylayoutbox", align = "right" })
    mylayoutbox[s]:mouse_add(mouse({ }, 1, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 3, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 4, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse({ }, 5, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s].text = "<bg image=\"/usr/share/awesome/icons/layouts/tilew.png\" resize=\"true\"/>"
end

-- Create a statusbar for each screen and add it
mystatusbar = {}
for s = 1, screen.count() do
    mystatusbar[s] = statusbar({ position = "top", name = "mystatusbar" .. s,
                                 fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the statusbar - order matters
    mystatusbar[s]:widgets({
        mytaglist,
        mytasklist,
        myiconbox,
        mypromptbox,
        mytextbox,
        mylayoutbox[s],
        s == 1 and mysystray or nil
    })
    mystatusbar[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
awesome.mouse_add(mouse({ }, 3, function () awful.spawn(config.terminal) end))
awesome.mouse_add(mouse({ }, 4, awful.tag.viewnext))
awesome.mouse_add(mouse({ }, 5, awful.tag.viewprev))
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
    
    keybinding({ config.modkey }, hotkey,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ config.modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ config.modkey, "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.movetotag(tags[sel.screen][i])
                           end
                       end
                   end):add()
    keybinding({ config.modkey, "Control", "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.toggletag(tags[sel.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ config.modkey }, "Left", awful.tag.viewprev):add()
keybinding({ config.modkey }, "Right", awful.tag.viewnext):add()
keybinding({ config.modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ config.modkey }, "Return", function () awful.spawn(config.terminal) end):add()

-- added by gregf
keybinding({ config.modkey }, "p", function() awful.spawn("exec `dmenu_path | dmenu -b`") end):add()
keybinding({ config.modkey }, "o", function() awful.spawn("exec /home/gregf/code/bin/clipboard/clipboard.sh") end):add()
keybinding({ config.modkey }, "n", function() awful.spawn("exec xterm -e screen -xRD") end):add()
keybinding({ config.modkey }, "g", function() awful.spawn("exec /home/gregf/code/bin/google/google.sh") end):add()
-- Application Launchers
keybinding({ config.superkey }, "m", function() awful.spawn("exec xterm -title mutt -e mutt") end):add()
keybinding({ config.superkey }, "l", function() awful.spawn("exec liferea") end):add()
keybinding({ config.superkey }, "f", function() awful.spawn("exec firefox") end):add()
keybinding({ config.superkey }, "h", function() awful.spawn("exec xterm -title htop -e htop") end):add()
keybinding({ config.superkey }, "p", function() awful.spawn("exec gmpc") end):add()

-- restart / quit
keybinding({ config.modkey, "Control" }, "r", awesome.restart):add()
keybinding({ config.modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ config.modkey }, "m", awful.client.maximize):add()
keybinding({ config.modkey, "Shift" }, "c", function () client.focus:kill() end):add()
keybinding({ config.modkey }, "j", function () awful.client.focusbyidx(1); client.focus:raise() end):add()
keybinding({ config.modkey }, "k", function () awful.client.focusbyidx(-1);  client.focus:raise() end):add()
keybinding({ config.modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding({ config.modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ config.modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ config.modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ config.modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ config.modkey, "Control" }, "Return", function () client.focus:swap(awful.client.master()) end):add()
--keybinding({ config.modkey }, "o", awful.client.movetoscreen):add()
keybinding({ config.modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ config.modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ config.modkey, "Shift" }, "r", function () client.focus:redraw() end):add()

-- Layout manipulation
keybinding({ config.modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ config.modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ config.modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ config.modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ config.modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ config.modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ config.modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ config.modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

--- Tabulous, tab manipulation
keybinding({ config.modkey, "Control" }, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)

    if not tabbedview then
        tabbedview = tabulous.tabindex_get(nextclient)

        if not tabbedview then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus)
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end):add()

keybinding({ config.modkey, "Shift" }, "y", tabulous.untab):add()

keybinding({ config.modkey }, "y", function ()
   local tabbedview = tabulous.tabindex_get()

   if tabbedview then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ config.modkey }, "t", awful.client.togglemarked):add()
keybinding({ config.modkey, 'Shift' }, "t", function ()
    local tabbedview = tabulous.tabindex_get()
    local clients = awful.client.getmarked()

    if not tabbedview then
        tabbedview = tabulous.tab_create(clients[1])
        table.remove(clients, 1)
    end

    for k,c in pairs(clients) do
        tabulous.tab(tabbedview, c)
    end

end):add()

for i = 1, keynumber do
    keybinding({ config.modkey, "Shift" }, "F" .. i,
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

-- {{{ Hooks
-- Hook function to execute when focusing a client.
function hook_focus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end

-- Hook function to execute when unfocusing a client.
function hook_unfocus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end

-- Hook function to execute when marking a client
function hook_marked(c)
    c.border_color = beautiful.border_marked
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c.border_color = beautiful.border_focus
end

-- Hook function to execute when the mouse is over a client.
function hook_mouseover(c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier" then
        client.focus = c
    end
end

-- Hook function to execute when a new client appears.
function hook_manage(c)
    -- Set floating placement to be smart!
    c.floating_placement = "smart"
    if config.titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { config.modkey })
    end
    -- Add mouse bindings
    c:mouse_add(mouse({ }, 1, function (c) client.focus = c; c:raise() end))
    c:mouse_add(mouse({ config.modkey }, 1, function (c) c:mouse_move() end))
    c:mouse_add(mouse({ config.modkey }, 3, function (c) c:mouse_resize() end))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    local role = c.role
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
    end
    
    -- Check application->screen/tag mappings.
    local target
    for i,t in ipairs(config.tags) do
        if t.apps then
            for k,w in pairs(t.apps) do
                local unmatched = nil

                if inst and inst:find(w) then awful.client.movetotag(tags[1][t.name], c)
                    elseif cls and cls:find(w) then awful.client.movetotag(tags[1][t.name], c)
                    elseif role and role:find(w) then awful.client.movetotag(tags[1][t.name], c)
                    --elseif inst and inst:find(w) then awful.client.movetotag(tags[1][t.name], c)
                    --elseif cls and cls:find(w) then awful.client.movetotag(tags[1][t.name], c)
                    else unmatched = true
                end
            end
        end
    end

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints
    client.focus = c
    c.honorsizehints = false
    if config.honorsizehints then
        c.honorsizehints = true
    end
end

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    local layout = awful.layout.get(screen)
    if layout then
        mylayoutbox[screen].text =
            "<bg image=\"/usr/share/awesome/icons/layouts/" .. awful.layout.get(screen) .. "w.png\" resize=\"true\"/>"
        else
            mylayoutbox[screen].text = "No layout."
    end

    -- If no window has focus, give focus to the latest in history
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    local sel = client.focus
    if sel then
        local c_c = sel:coords()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end

-- Hook called every second
function hook_timer ()
    if config.time_t then
        -- For unix time_t lovers
        mytextbox.text = " " .. os.time() .. " "
        -- Otherwise use:
    else
        mytextbox.text = " " .. os.date(config.date_format) .. " "
    end
end

-- Set up some hooks
awful.hooks.focus.register(hook_focus)
awful.hooks.unfocus.register(hook_unfocus)
awful.hooks.marked.register(hook_marked)
awful.hooks.unmarked.register(hook_unmarked)
awful.hooks.manage.register(hook_manage)
awful.hooks.mouseover.register(hook_mouseover)
awful.hooks.arrange.register(hook_arrange)
awful.hooks.timer.register(1, hook_timer)
-- }}}
