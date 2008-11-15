-- configuration
print("Configuration Loaded...")

-- {{{ TODO
-- dmenu front end to mpc
-- redo tagging
-- vim modeline
-- configurable dmenu theme
-- load seperate file for configuration.
-- comments for configration options
-- pick few layouts, for quicker cycling with mod+space
-- playwith config.startup again, find a way to make them only run once, pgrep?
-- maybe create a dark theme as well. white on black.
-- extend config.floating, make it less about floating and more aboat hard
--      coding a layout on a per application basis. With regex?
--  Map tags differently. Instead of F1..F9 use 1..5 then q..r(6..9)
--  Config option true/false for taskbar.
--  Config option true/false to display the widget bar, hotkey to turn on off
--  Hash for Config.menu
-- }}} 

-- {{{ Config settings 
config = {}
config.apps = {}
config.keys = {}
config.maps = {}
config.tags = {}
config.layouts = {}
config.float = {}
config.theme = {}
config.menu = {}

-- {{{ Keys
-- Setup some default key bindings.
config.keys.alt = "Mod1"
config.keys.super = "Mod4"
config.keys.shift = "Shift"
config.keys.control = "Control"
config.keys.modkey = config.keys.alt
--[[
config.keys.super_shift = config.keys.super, config.keys.shift
config.keys.super_control = config.keys.super, config.keys.control
config.keys.alt_control = config.keys.alt, config.keys.control
config.keys.alt_shift = config.keys.alt, config.keys.shift
--]]
-- }}}

-- {{{ dmenu theme options
-- dmenu theme settings
config.apps.dmenu_nb = " -nb #303030"
config.apps.dmenu_nf = " -nf #CCCCCC"
config.apps.dmenu_sb = " -sb #97B26B"
config.apps.dmenu_sf = " -sf #000000"
-- }}}

-- {{{ Apps
config.apps.terminal = "xterm"
config.apps.browser = "firefox"
config.apps.editor = os.getenv("EDITOR") or "vim"
config.apps.editor_cmd = config.apps.terminal .. " -e " .. config.apps.editor
config.apps.rss = "liferea"
config.apps.music = "gmpc"
config.apps.vm = "Virtualbox"
config.apps.mail = config.apps.terminal.." -T mutt -e mutt"
config.apps.chat = "gajim"
config.apps.burn = "k3b"
config.apps.screen = config.apps.terminal.." -e screen"
config.apps.filemanager = "thunar"
-- bindings for mpc/mpd
config.apps.stop_music = "mpc stop"
config.apps.toggle_music = "mpc toggle"
config.apps.pause_music = "mpc pause"
config.apps.play_music = "mpc play"
config.apps.next_music = "mpc next"
config.apps.prev_music = "mpc prev"
config.apps.dmenu = "dmenu_run"
config.apps.dmenu_cmd = config.apps.dmenu.." -b "..config.apps.dmenu_nb..config.apps.dmenu_nf..config.apps.dmenu_sb..config.apps.dmenu_sf
-- }}}

-- {{{ Config settings 
config.home = os.getenv("HOME")
config.theme_name = "darkone/theme" or "gregf/theme"
config.theme_path =  awful.util.getdir("config") .. "/themes/"
config.theme = config.theme_path..config.theme_name

-- tag bindings
dev = 1
www = 2 
im = 3 
news = 4 
music = 5 
mail = 6 
irc = 7 
media = 8 
misc = 9

-- Table of layouts to cover with awful.layout.inc, order matters.
config.layouts = {
    --"tile",
    "tileleft",
    "tilebottom",
    "tiletop",
    --"fairh",
    "fairv",
    --"magnifier",
    "max",
    --"spiral",
    --"dwindle",
    "floating",
    "fullscreen"
}

-- Table of clients that should be set floating. The index may be either
-- application WM_CLASS, WM_INSTANCE, WM_NAME
config.float = {
    ["MPlayer"] = true,
    --["gajim.py"] = true,
    ["gimp"] = true
}

config.tags = {
    { tag = 1,  name = "dev",    layout = "tiletop",     key = "1", },
    { tag = 2,  name = "www",     layout = "max",         key = "2", },
    { tag = 3,  name = "im",      layout = "floating",    key = "3", },
    { tag = 4,  name = "news",    layout = "max",         key = "4", },
    { tag = 5,  name = "music",   layout = "max",         key = "5", },
    { tag = 6,  name = "mail",    layout = "max",         key = "q", },
    { tag = 7,  name = "irc",     layout = "tiletop",     key = "w", },
    { tag = 8,  name = "media",    layout = "tiletop",     key = "e", },
    { tag = 9,  name = "misc",    layout = "tiletop",     key = "r", }
}

-- possible add tagnumber and layout into this?
config.maps = {
    { name = music, screen = 1,     apps = {"gmpc"}, },
    { name = www,   screen = 1,     apps = {".*Firefox"}, },
    { name = media,  screen = 1,     apps = {".?DownThemAll!", "Downloads", "DTA"}, },
    { name = im,    screen = 1,     apps = { "gajim.*"}, },
    { name = news,  screen = 1,     apps = {"liferea"}, },
    { name = misc,  screen = 1,     apps = {"k3b", "Deluge", "gpodder"}, },
    { name = mail,  screen = 1,     apps = {"mutt"}, },
    { name = dev,  screen = 1,     apps = {"htop"}, },
    { name = irc,   screen = 1,     apps = {"XChat.*", "irssi"}, }
}

-- {{{ Menu
config.menu = {
    root = {
        { "open terminal", config.apps.terminal },
        { "awesome", config.menu.root, "/usr/share/awesome/icons/awesome16.png" }
    },
    myawesomemenu = {
       { "manual", config.apps.terminal .. " -e man awesome" },
       { "edit config", config.apps.editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
       { "restart", awesome.restart },
       { "quit", awesome.quit }
    },
}
--- }}}

-- Define if we want to use titlebar on all applications.
config.titlebar = false 
-- Display the systray applets
config.systray = true 
-- Enable mouse warping
config.mouse_warping = false 

-- set time_t to true if you would rather use that over date_format
config.time_t = false 
config.date_format = "%A %B %d %I:%M:%S%P"

config.iconbox = false 
-- honorsizehints when set to true leaves a gap between client windows.
config.honorsizehints = false 


--[[naughty.notify({ text = "notification",]]
                 --title = "title",
                 --position = "top_right",
                 --timeout = 5,
                 ----icon="/path/to/image",
                 --fg="#FFFFFF",
                 --bg="#000000",
                 --[[screen = 1 })]]

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
