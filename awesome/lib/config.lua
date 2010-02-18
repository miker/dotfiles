--  ----------------------------------------------------------------------------
-- File:     ~/.config/awesome/libs/config.lua
-- Author:   Greg Fitzgerald <netzdamon@gmail.com>
-- Modified: Sat 24 Oct 2009 1:39:10 PM EDT
--  ----------------------------------------------------------------------------

-- {{{ TODO
-- Use colors from beautiful/theme for dmenu
-- Ditch shifty use the new Rules method, map firefox by class to avoid flash fullscreen bug
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
config.apps.terminal = os.getenv("TERMCMD") or "urxvt"
config.apps.tmux = "urxvt -e tmux -2"
config.apps.browser = os.getenv("BROWSER") or "firefox"
config.apps.editor = os.getenv("EDITOR") or "vim"
config.apps.editor_cmd = config.apps.terminal .. " -e " .. config.apps.editor
config.apps.graphical_editor = "gvim"
config.apps.music = config.apps.terminal.." -name ncmpcpp -e ncmpcpp"
config.apps.mail = config.apps.terminal.." -name mutt -e mutt"
config.apps.chat = "gajim"
config.apps.burn = "xfburn"
config.apps.filemanager = "thunar"
config.apps.irc = "xchat2"
config.apps.bitorrent = "deluge"
config.apps.lock = "xlock"
config.apps.launcher = "dmenu_run -i -b -nb '#303030' -nf '#CCCCCC' -sb '#97B26B' -sf '#000000'"
-- }}}

-- {{{ Theme Settings 
config.home = os.getenv("HOME")
config.theme_name = "darkone/theme" or "gregf/theme"
config.theme_path =  awful.util.getdir("config") .. "/themes/"
config.theme = config.theme_path..config.theme_name
-- }}}

config.date_format = " %a %b %d, %I:%M "

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
