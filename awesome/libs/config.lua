--  ----------------------------------------------------------------------------
-- File:     ~/.config/awesome/libs/config.lua
-- Author:   Greg Fitzgerald <netzdamon@gmail.com>
-- Modified: Tue 03 Mar 2009 09:51:50 PM EST
--  ----------------------------------------------------------------------------

-- {{{ TODO
-- dmenu front end to mpc
-- redo tagging
-- configurable dmenu theme
-- comments for configration options
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
config.theme = {}

-- {{{ Keys
-- Setup some default key bindings.
config.keys.alt = "Mod1"
config.keys.super = "Mod4"
config.keys.shift = "Shift"
config.keys.control = "Control"
config.keys.modkey = config.keys.alt
-- }}}

-- {{{ Apps
--config.apps.terminal = "xterm"
config.apps.terminal = "urxvt"
config.apps.browser = "epiphany -n"
config.apps.editor = os.getenv("EDITOR") or "vim"
config.apps.editor_cmd = config.apps.terminal .. " -e " .. config.apps.editor
config.apps.rss = "liferea"
config.apps.music = "gmpc"
--config.apps.mail = config.apps.terminal.." -T mutt -n mutt -e 'TERM=xterm-256color mutt'"
config.apps.mail = config.apps.terminal.." -name mutt -e mutt"
config.apps.chat = "gajim"
config.apps.burn = "k3b"
config.apps.screen = config.apps.terminal.." -e screen"
config.apps.filemanager = "thunar"
-- }}}

-- {{{ Theme Settings 
config.home = os.getenv("HOME")
config.theme_name = "darkone/theme" or "gregf/theme"
config.theme_path =  awful.util.getdir("config") .. "/themes/"
config.theme = config.theme_path..config.theme_name
-- }}}

-- Define if we want to use titlebar on all applications.
config.titlebar = false 
-- Display the systray applets
config.systray = true 

--config.date_format = "%A %B %d %I:%M:%S%P"
config.date_format = " %a %b %d, %I:%M "

config.iconbox = false 
-- honorsizehints when set to true leaves a gap between client windows.
config.honorsizehints = false 

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
