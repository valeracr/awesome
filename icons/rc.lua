-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
vicious         = require("vicious")
local lain      = require("lain")
require("applicationsmenu")
cal = require("cal")
scratch = require("scratch")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
beautiful.init("/home/valera/.config/awesome/themes/colored/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "leafpad"
--editor_cmd = terminal .. " -e " .. editor
editor_cmd = "leafpad"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,    
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
names = { "Ƅ", "ƀ", "Ɵ", "ƈ", "Ɗ" },
--names = {"➊", "➋", "➌", "➍", "➎",},
layout = {layouts[1], layouts[1], layouts[1], layouts[2], layouts[3]}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout) 
        awful.tag.setnmaster(0, tags[s][1])
	awful.tag.setncol(4, tags[s][1])
	--awful.tag.setproperty(tags[s][1], "mwfact", 0.50)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

standart_menu = {
    { "MC", "urxvt -e mc" },
    { "PCManFM", "pcmanfm" },
    { "CHROME", "google-chrome-stable" },
    { "FiReFox", "firefox"},
    { "Google-Earth", "google-earth6"},
    { "Terminal", "xterm" }              
}

mymainmenu = awful.menu({ items = { { "menu", applicationsmenu.applicationsmenu (), beautiful.awesome_icon },
                                    { "awesome", myawesomemenu, "/home/valera/.config/awesome/themes/zenburn/awesome-icon.png" },
                                    { "PR", standart_menu, "/home/valera/pictures/1g.png" },
                                    { "Terminal", terminal, "/home/valera/.icons/buuf3.6/128x128/Zimages/screen.png" },
                                    { "HOME", "stuurman", "/home/valera/.icons/buuf3.6/128x128/Zimages/house2.png" },
                                    { "OPERA", "opera", "/home/valera/.icons/buuf3.6/24x24/Zimages/O-red.png" },
                                    { "Reboot", "reboot", "/home/valera/.icons/ubo-icons-0.1alpha/24x24/actions/edit-undo.png"},
                                    { "STOP",  "poweroff", "/home/valera/.icons/ubo-icons-0.1alpha/24x24/actions/gnome-shutdown.png"}
                                   }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
--mytextclock = awful.widget.textclock(" <span font=\"Comic Sans MS 8\"><b>%H:%M</b></span> ")
mytextclock = awful.widget.textclock(" <span font=\"odstemplik 14\"><b>%H:%M</b></span> ")
mytextclockicon = wibox.widget.imagebox()
mytextclockicon:set_image("/home/valera/.icons/ubo-icons-0.1alpha/128x128/apps/xclock.png")
-- calendar
lain.widgets.calendar:attach(mytextclockicon, { font_size = 10})
--cal.register(mytextclockicon, "<span color=\"#0400ff\"><b>%s</b></span>")
--cal.register(mytextclockicon)
--{{{--Kbdd----------------------------------------------------------------

kbdwidget = wibox.widget.textbox()
kbdwidget.border_width = 3
kbdwidget:set_markup(" <span color=\"#ffde00\"><b> ⌨ ℰN</b></span> ")
dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    lts = {[0] = " <span color=\"#ffde00\"><b> ⌨ ℰN</b></span> ", [1] = " <span color=\"#0400ff\"><b> ⌨ℜU</b></span> "}
    kbdwidget:set_markup(" " .. lts[layout])
end
)

--kbdwidget:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn("dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.prev_layout") end)))
--kbdwidget:buttons(awful.util.table.join(awful.button({}, 3, function () awful.util.spawn("dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.set_layout uint32:1") end)))
--))

---{{{-Batery------------------------------------------------------
baticcon = wibox.widget.imagebox()
baticcon:set_image(beautiful.widget_batfull)
batpct = wibox.widget.textbox()
batpct:set_font("odstemplik Bold 14")
vicious.register(batpct, vicious.widgets.bat, function(widget, args)
  bat_state  = args[1]
  bat_charge = args[2]
  bat_time   = args[3]
  if args[1] == "-" then
    if bat_charge > 70 then
      baticcon:set_image(beautiful.widget_batfull)
    elseif bat_charge > 30 then
      baticcon:set_image(beautiful.widget_batmed)
    elseif bat_charge > 10 then
      baticcon:set_image(beautiful.widget_batlow)
    else
      baticcon:set_image(beautiful.widget_batempty)
    end
  else
    baticcon:set_image(beautiful.widget_ac)
    if args[1] == "+" then
    end
  end
  return args[2] .. "%"
end, nil, "BAT0")
-- Buttons
function popup_bat()
  local state = ""
  if bat_state == "↯" then
    state = "Full"
  elseif bat_state == "↯" then
    state = "Charged"
  elseif bat_state == "+" then
    state = "Charging"
  elseif bat_state == "-" then
    state = "Discharging"
  elseif bat_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end
  naughty.notify { text = "Charge : " .. bat_charge .. "%\nState  : " .. state ..
    " (" .. bat_time .. ")", timeout = 5, hover_timeout = 0.5 }
end
--batpct:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
--baticcon:buttons(batpct:buttons())
---------------------------------------------------------------------------
memicon = wibox.widget.imagebox()
memicon:set_image("/home/valera/.icons/ubo-icons-0.1alpha/128x128/apps/gnome-monitor.png")
local function disptemp()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("sensors")
	infos = f:read("*all")
	f:close()

	showtempinfo = naughty.notify( {
		text	= infos,
		timeout	= 0,
        position = "top_right",
        margin = 10,
        height = 115,
        width = 200,
        border_color = '#404040',
        border_width = 2,
        -- opacity = 0.95,
		screen	= capi.mouse.screen })
end

memicon:connect_signal('mouse::enter', function () disptemp(path) end)
memicon:connect_signal('mouse::leave', function () naughty.destroy(showtempinfo) end)

memicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e htop", false) end)
))

-- {{{ Volume

volicon = wibox.widget.imagebox()
volicon:set_image("/home/valera/.icons/ubo-icons-0.1alpha/128x128/apps/xfce4-notifyd.png")
--volumewidget = wibox.widget.textbox()
--vicious.register( volumewidget, vicious.widgets.volume, "<span color=\"#ffde00\">$1%</span>", 1, "Master" )
volicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("".. terminal.. " -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 1dB-", false) end)
))

space = wibox.widget.textbox()
space:set_text('⥣')
space1 = wibox.widget.textbox()
space1:set_text("   ")
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

--Виджет imagebox старта приложения на примере firefox (аналог панели быстрого старта в шиндошс хр)
myapp1start = wibox.widget.imagebox()
--Задаём иконку приложения
myapp1start:set_image("/home/valera/.icons/buuf3.6/16x16/Zimages/O-red.png")
--myapp1start:set_image(beautiful.myapp1icon)
--Добавляем действие по щелчку мыши левой кнопкой
myapp1start:buttons(awful.util.table.join(       
        awful.button({ }, 1, function () awful.util.spawn_with_shell("pgrep -u $USER -x opera || (opera)")  end)
        ))
myapp2start = wibox.widget.imagebox()
myapp2start:set_image("/home/valera/.icons/buuf3.6/128x128/Zimages/house2.png")
myapp2start:buttons(awful.util.table.join(       
        awful.button({ }, 1, function () awful.util.spawn_with_shell("pgrep -u $USER -x stuurman || (stuurman)")  end)
        ))
myapp3start = wibox.widget.imagebox()
myapp3start:set_image("/home/valera/.icons/Iconos-2/Monitor-final-on-fs.png")
myapp3start:buttons(awful.util.table.join(       
        awful.button({ }, 1, function () awful.util.spawn_with_shell("pgrep -u $USER -x urxvt || (urxvt)")  end)
        ))
myapp4start = wibox.widget.imagebox()
myapp4start:set_image("/home/valera/.icons/book/book64.png")
--myapp4start:set_image("/home/valera/Images/2g.png")
myapp4start:buttons(awful.util.table.join(       
        awful.button({ }, 1, function () awful.util.spawn_with_shell("pgrep -u $USER -x cr3 || (cr3)")  end)
        ))

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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                      awful.button({ }, 2, function (c)  c:kill()                         end),
                      
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    
    -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(space1)
    left_layout:add(space)
    left_layout:add(myapp1start)
    left_layout:add(space)
    left_layout:add(myapp2start)
    left_layout:add(space)
    left_layout:add(myapp3start)
    --left_layout:add(myapp5start)
    left_layout:add(space)
    left_layout:add(myapp4start)
    left_layout:add(space)   
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    --right_layout:add(spr)
    --right_layout:add(arrl)
    --right_layout:add(arrl_ld)
    right_layout:add(kbdwidget)
    --right_layout:add(arrl_dl)
    right_layout:add(space)
    right_layout:add(baticcon)
    right_layout:add(batpct)
    --right_layout:add(arrl_ld)
    right_layout:add(space)
    right_layout:add(memicon)
    right_layout:add(space)
    --right_layout:add(arrl_dl)
    right_layout:add(volicon)
    right_layout:add(space)
   -- right_layout:add(arrl_ld)
    right_layout:add(mytextclockicon)
    right_layout:add(mytextclock)
    --right_layout:add(spr)
    --right_layout:add(arrl_dl)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
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
    awful.key({ modkey, }, "b", function ()
    mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ }, "F6", function () scratch.pad.toggle() end),
    awful.key({ }, "F7", function () scratch.drop("urxvt", "bottom", nil, nil, 0.30) end),
    --awful.key({ }, "F2", function () scratch.drop("opera", c, nil, nil, 1.00, 0.90) end),
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

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
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ 0                 }, "F3",  function () awful.util.spawn ("pcmanfm") end),
    awful.key({ 0                 }, "F2",    function () awful.util.spawn ("opera") end),
    awful.key({ 0                 }, "F4",    function () awful.util.spawn ("xwinmosaic -S") end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ 0 },            "Menu",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ }, "F5", function (c) scratch.pad.set(c, 0.80, 0.60, true) end),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },  
    { rule = { instance = "plugin-container" },
     properties = { floating = true } },
    { rule = { class = "Sopcast-player.py" },
      properties = { floating = true },  
      callback = function (c)
      awful.placement.centered(c,nil)
     end
  },
    { rule = { class = "Blueman-manager" },
      properties = { floating = true } },
    { rule = { class = "Gnome-mplayer" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "Dialog" },
      properties = { floating = true } },
    { rule = { class = "Grun" },
      properties = { floating = true } },
    { rule = { class = "Xmessage" },
      properties = { floating = true } },
    { rule = { class = "Xwinmosaic" },
      properties = { floating = true },
     properties = { floating = true },  
      callback = function (c)
      awful.placement.centered(c,nil)
     end
  },
    { rule = { class = "Gxmessage" },
      properties = { floating = true } }, 
    { rule = { class = "pinentry" },
      properties = { floating = true } },  
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
     properties = { floating = true } },
     { rule = { instance = "htop" },
                                  properties = {  tag = tags[1][4]    } },
    { rule = { instance = "mc [valera@arch]:~" },
                                  properties = {  tag = tags[1][4]    } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
--    c:connect_signal("mouse::enter", function(c)
--        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--          and awful.client.focus.filter(c) then
--          client.focus = c
--     end
--  end)
c.size_hints_honor = false
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
awful.util.spawn_with_shell("run_once kbdd")
awful.util.spawn_with_shell("run_once /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
awful.util.spawn_with_shell("run_once touchpad11")
--awful.util.spawn_with_shell("setxkbmap -layout 'us, ru' -option 'grp:caps_toggle'")