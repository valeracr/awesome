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
local blingbling = require("blingbling")
require("applicationsmenu")
--cal = require("calendar")
scratch = require("scratch")
local APW = require("apw/widget")
--require("yawn")
---------------------------------
--------------------------------
 --
--cpu1=blingbling.wlourf_circle_graph()
----cpu1:set_radius(10)
--cpu1:set_graph_colors({{"#f70101ff",0}, --all value > 0 will be displayed using this color
--{"#bab46eff", 0.5},
--{"#f29466ff",0.77}})
----vicious.register(cpu1, vicious.widgets.cpu,'$1',2)
--vicious.register(cpu1, vicious.widgets.cpu, "$2")
--vicious.register(cpu1, vicious.widgets.mem, '$2', 2)
--fixedwidget6 = wibox.layout.constraint(cpu1, "exact", 20)
---------------------
sensors = wibox.widget.textbox()
vicious.register(sensors, vicious.widgets.sensors, "<span <span color=\"#e65117\"><b>$2</b></span>", 5)
--sensors:set_font("odstemplik Bold 18")
fixedwidget1 = wibox.layout.constraint(sensors, "exact", 65)
--fixedwidget1:set_width(70)

--CPU---------------
-- Инициализация виджета
cpuwidget = awful.widget.graph()
-- Свойства графика
cpuwidget:set_width(50)
cpuwidget:set_background_color("#00000080")
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#ed0c0c"}, {0.5, "#71e21b"}, 
                    {1, "#ee170c" }}})
-- Регистрация виджета
vicious.register(cpuwidget, vicious.widgets.cpu, "$1" ,1)

-- Инициализация виджета
cpuwidget2 = wibox.widget.textbox()
-- Регистрация виджета
vicious.register(cpuwidget2, vicious.widgets.cpu, "$1%" ,2)
fixedwidget = wibox.layout.constraint(cpuwidget2, "exact", 35)

--{{{--Kbdd----------------------------------------------------------------

function change()
kbd_next_cmd = "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.next_layout"
awful.util.spawn_with_shell(kbd_next_cmd)
end
kbdwidget = wibox.widget.textbox()

kbdwidget:set_markup("<span color=\"#e65117\"><b><span font=\"odstemplik Bold 11\">⌨ </span>ℰN</b></span>")
dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
        local data = {...}
        local layout = data[2]
        lts = {[0] = "<span color=\"#e65117\"><b><span font=\"odstemplik Bold 11\">⌨ </span>ℰN</b></span>", [1] = "<span color=\"#0400ff\"><b><span font=\"odstemplik Bold 11\">⌨ </span>ℜU</b></span>"}
        kbdwidget:set_markup(lts[layout])
        end
        )
fixedwidget4 = wibox.layout.constraint(kbdwidget, "exact", 54)
kbdwidget:buttons(awful.util.table.join(awful.button({ }, 1, change)))
        



memicon = wibox.widget.imagebox()
memicon:set_image("/home/valera/.icons/Black Diamond-V2/scalable/apps/gnome-system-monitor.png")
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
                font = "odstemplik Bold 18",
		text	= infos,
		timeout	= 0,
        position = "top_right",
        margin = 10,
        height = 200,
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

-- Memory
memwidget = wibox.widget.textbox()
--vicious.register(memwidget, vicious.widgets.mem, "<span font=\"odstemplik Bold 14\"><b>$2/$3</b></span>", 1)
--vicious.register(memwidget, vicious.widgets.mem, "<span font=\"odstemplik Bold 18\"><b>$2 m</b></span>", 5)
vicious.register(memwidget, vicious.widgets.mem, "<span >$2 m</span>", 5)
fixedmemwidget = wibox.layout.constraint(memwidget, "exact", 147)
memwidget:set_align("center")
memicon3 = wibox.widget.imagebox()
memicon3:set_image("/home/valera/sharingan-icons-1.5/speedownload.png")
fixedwidget3 = wibox.layout.constraint(memwidget, "exact", 50)
--fixedwidget3:set_width(50)

-- {{{ Volume

volicon = wibox.widget.imagebox()
volicon:set_image("/usr/share/icons/Black Diamond-V2/scalable/apps/armagetronad.png")
--volumewidget = wibox.widget.textbox()
--vicious.register( volumewidget, vicious.widgets.volume, "<span color=\"#ffde00\">$1%</span>", 1, "Master" )
volicon:buttons(awful.util.table.join(
    awful.button({ }, 2, function () awful.util.spawn("xfce4-mixer") end)
))
--memicon4 = wibox.widget.imagebox()
--memicon4:set_image("/home/valera/.config/awesome/21.png")
--memicon4:buttons(awful.util.table.join(
--    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e 'yaourt -Syyu --aur'", false) end)
--))
-----------------------------------------------
-- {{{ PACMAN
-- Icon
--pacicon = wibox.widget.imagebox()
--pacicon:set_image(beautiful.widget_pac)
--
pacman = wibox.widget.textbox("<span color=\"#e65117\"><b>☠</b></span>")
pacman:set_font("Comic Sans MS 16")
pacman:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e 'yaourt -Syyu --aur'", false) end)
))
-- Pacman Widget
pacwidget = wibox.widget.textbox()

pacwidget_t = awful.tooltip({ objects = { pacwidget},})

vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    --local s = io.popen("pacman -Qu -b /tmp/checkup-db-valera")
                    local s = io.popen("/usr/bin/checkupdates")
                    local str = ''
		    local i = 0

                    for line in s:lines() do
                        str = str .. line .. "\n"
                        i = i + 1
		    end
                    pacwidget_t:set_text(str)
                    s:close()
                    return "<span color=\"#e65117\"><b>:"  .. i ..  "</b></span>"
                end, 1800, "Arch C")
pacwidget:set_font("odstemplik Bold 17")

--
-- Buttons
  function popup_pac()
  local pac_updates = ""
--  local f = io.popen("pacman -Sup --dbpath /tmp/checkup-db-valera")
  local f = io.popen("/usr/bin/checkupdates")
  if f then
  pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  end
  f:close()
  if not pac_updates then
  pac_updates = "System is up to date"
  end
  naughty.notify { text = pac_updates }
  end
pacwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("".. terminal.. " -e 'yaourt -Syyu --aur'", false) end)
))
--pacwidget:buttons(awful.util.table.join(awful.button({ }, 3, popup_pac)))
--  pacicon:buttons(pacwidget:buttons())
-- End Pacman
--------------------------------------------------
-- Network Widget
netwidget = blingbling.net({ interface = "enp3s0", show_text = false })
netwidget:set_ippopup()
netwidget:set_graph_line_color("#e65117ff")
--netwidget:set_background_color("#f7010150")
netwidget:set_graph_color("#f70101ff")
--netwidget:set_background_graph_color("#00ea00ff")
netwidget:set_text_color("#e65117")
netwidget:set_font("Sony Sketch EF Bold")
netwidget:set_font_size(11)
netwidget.height = 0.50
fixedwidget5 = wibox.layout.constraint(netwidget, "exact", 23)
-----------
----
space = wibox.widget.textbox()
space:set_text('⥣')
space1 = wibox.widget.textbox()
space1:set_text("  ")
spr = wibox.widget.textbox('')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)

--Виджет imagebox старта приложения на примере firefox (аналог панели быстрого старта в шиндошс хр)
--myapp1start = wibox.widget.imagebox()
--Задаём иконку приложения
--myapp1start:set_image("/home/valera/.icons/Black Diamond-V2/scalable/apps/firefox.png")
--myapp1start:set_image(beautiful.myapp1icon)
--Добавляем действие по щелчку мыши левой кнопкой
--myapp1start:buttons(awful.util.table.join(       
--        awful.button({ }, 1, function () awful.util.spawn_with_shell("pgrep -u $USER -x firefox || (firefox)")  end)
--        ))
-- Create a laucher widget
myapp1start = awful.widget.launcher({ name = "firefox",
                                     image = "/home/valera/.config/awesome/appicons/firefox.png",
                                     command = "firefox"})

-- Create a laucher widget
myapp2start = awful.widget.launcher({ name = "thunar",
                                     image = "/home/valera/.config/awesome/appicons/thunar.png",
                                     command = "thunar"})

-- Create a laucher widget
myapp3start = awful.widget.launcher({ name = "xfce4-terminal",
                                     image = "/home/valera/.config/awesome/appicons/xfce4-terminal.png",
                                     command = "xfce4-terminal"})

-- Create a laucher widget
myapp4start = awful.widget.launcher({ name = "fbreader",
                                     image = "/home/valera/.config/awesome/appicons/cr3.png",
                                     command = "FBReader"})

-- Create a laucher widget
myapp5start = awful.widget.launcher({ name = "palemoon",
                                     image = "//home/valera/.config/awesome/appicons/palemoon.png",
                                     command = "palemoon"})

-- Create a laucher widget
myapp7start = awful.widget.launcher({ name = "opera",
                                     image = "/home/valera/.config/awesome/appicons/opera.png",
                                     command = "opera"})