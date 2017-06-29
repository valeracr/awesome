------------------------------------------------
--         Full Color Awesome Theme           --    
--          by TheImmortalPhoenix             --
-- http://theimmortalphoenix.deviantart.com/  --
------------------------------------------------

-- {{{ Main

theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/colored"
theme.wallpaper = "/home/valera/.config/awesome/NP1.png"
-- }}}
theme.widget_ac = "~/.config/awesome/icons/ac.png"
theme.widget_acblink = "~/.config/awesome/icons/acblink.png"
theme.widget_batfull = "~/.config/awesome/icons/batfull.png"
theme.widget_batmed = "~/.config/awesome/icons/batmed.png"
theme.widget_batlow = "~/.config/awesome/icons/batlow.png"
theme.widget_batempty = " ~/.config/awesome/icons/batempty.png"

-- }}}

-- {{{ Font
--theme.font                          = "Tewi 8"
theme.taglist_font                  = "Icons 8"
--theme.font      = "Terminus Re33 Bold 10"
theme.font      = "Sony Sketch EF 11"
--theme.font = "odstemplik 18"
-- }}}

-- {{{ Colors

--theme.bg_systray = theme.bg_normal
theme.bg_systray =    "#250502"
theme.bg_normal     = "#08080810"
theme.bg_focus      = "#08080810"
theme.bg_urgent     = "#08080810"
theme.bg_minimize   = "#08080810"

theme.fg_normal     = "#f70101"
--theme.fg_focus      = "#7788af"
theme.fg_focus      = "#e65117"
theme.fg_urgent     = "#94738c"
theme.fg_minimize   = "#444444"

theme.fg_black      = "#424242"
theme.fg_red        = "#ce5666"
theme.fg_green      = "#80a673"
theme.fg_yellow     = "#ffaf5f"
theme.fg_blue       = "#7788af"
theme.fg_magenta    = "#94738c"
theme.fg_cyan       = "#778baf"
theme.fg_white      = "#aaaaaa"
theme.fg_blu        = "#8ebdde"

-- }}}

-- {{{ Borders

theme.border_width  = 1
theme.border_normal = "#910101"
--theme.border_normal = "#f70101"
--theme.border_focus  = "#e65117"
theme.border_focus  = "#e65117"
theme.border_marked = "#d46912"

-- }}}

-- {{{ Menu

theme.menu_height       = "20"
theme.menu_width        = "150"
theme.menu_border_width = "3"
theme.menu_fg_normal    = "#e31616"   --color txt pip
theme.menu_fg_focus     = "#721515"
theme.menu_bg_normal    = "#08080870"   --background menu
theme.menu_bg_focus     = "#08080870"

-- }}}

-- {{{ Icons
theme.icon_theme = "gnome"
theme.awesome_icon           = "/home/valera/.config/awesome/face.png"
--theme.awesome_icon           = "/usr/share/awesome/themes/zenburn/awesome-icon.png"
--theme.menu_submenu_icon      = "/usr/share/awesome/themes/zenburn/awesome-icon.png"
-- {{{  Widget icons

theme.widget_uptime     = theme.confdir .. "/widgets/magenta/ac_01.png"
theme.widget_cpu        = theme.confdir .. "/widgets/green/cpu.png"
theme.widget_temp       = theme.confdir .. "/widgets/yellow/temp.png"
theme.widget_mem        = theme.confdir .. "/widgets/green/mem.png"
theme.widget_fs         = theme.confdir .. "/widgets/cyan/usb.png"
theme.widget_netdown    = theme.confdir .. "/widgets/red/net_down_03.png"
theme.widget_netup      = theme.confdir .. "/widgets/green/net_up_03.png"
theme.widget_gmail      = theme.confdir .. "/widgets/magenta/mail.png"
theme.widget_sys        = theme.confdir .. "/widgets/green/dish.png"
theme.widget_pac        = theme.confdir .. "/widgets/green/pacman.png"
theme.widget_batt       = theme.confdir .. "/widgets/yellow/bat_full_01.png"
theme.widget_clock      = theme.confdir .. "/widgets/cyan/clock.png"
theme.widget_vol        = theme.confdir .. "/widgets/cyan/spkr_01.png"
theme.arrl                          = theme.confdir .. "/icons/arrl.png"
theme.arrl_dl                       = theme.confdir .. "/icons/arrl_dl.png"
theme.arrl_ld                       = theme.confdir .. "/icons/arrl_ld.png"
-- }}}
theme.hotkeys_group_margin = "#oooooo"
-- {{{ Taglist

theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"

--theme.taglist_squares_resize = "false"

-- }}}
theme.myapp5icon = "/usr/share/icons/hicolor/32x32/apps/firefox.png"
-- {{{ Misc

theme.tasklist_floating_icon = theme.confdir .. "/floating.png"

-- }}}
-- {{{ Gaps
theme.useless_gap       = 0
theme.gap_single_client = true


-- }}}


-- {{{ Layout

theme.layout_tile       = theme.confdir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts/floating.png"
theme.layout_centerwork   = theme.confdir .. "/layouts/gimp.png"

-- }}}

-- }}}

return theme
