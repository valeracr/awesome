------------------------------------------------------------------------------
--
--	Аналоговые часы
--	(с) maisvendoo, 09.06.2013 
--
------------------------------------------------------------------------------

local wibox = require("wibox")
local capi = {timer = timer}

clock = {}

-------------------------------------------------------------------------------
--	Параметры часов
-------------------------------------------------------------------------------
clock.width = 150		-- ширина
clock.height = 150		-- высота
clock.bg_color = "#00000000"	-- цвет фона

clock.x = 10			-- Координаты
clock.y = 450			-- левого верхнего угла

-------------------------------------------------------------------------------
--	Создаем wibox
-------------------------------------------------------------------------------
local clock_wbox = wibox({ bg = clock.bg_color, 
                           width = clock.width, 
			   height = clock.height})

clock_wbox.ontop = false			-- Ниже всех окон
clock_wbox.visible = true			-- Виден
clock_wbox:geometry({x = clock.x, y = clock.y})	-- Координаты 

-------------------------------------------------------------------------------
--	Создаем виджет
-------------------------------------------------------------------------------
local clock_widget = wibox.widget.base.make_widget()

-------------------------------------------------------------------------------
--	Функция, определяющая размеры виджета 
-------------------------------------------------------------------------------
clock_widget.fit = function(clock_widget, width, height)

  return width, height
  
end

-------------------------------------------------------------------------------
--	Функция отрисовки
-------------------------------------------------------------------------------
clock_widget.draw = function(clock_widget, clock_wbox, cr, width, height)

  -- Определяем характерные размеры, относительно текущей ширины виджета
  local radius = width/2 - 5
  local cx = width/2
  local cy = height/2

  local hour_len = 8
  local min_len = 7

  -- Рисуем циферблат
  
  -- Рисуем часовые деления
  cr:set_line_width (2)
  cr:set_source_rgba (0.7, 0.7, 0.7, 1)

  for i = 0,11 do

	cr:move_to (cx + (radius - hour_len)*math.sin(i*math.rad(30)), cy - (radius - hour_len)*math.cos(i*math.rad(30)) )
	cr:line_to (cx + radius*math.sin(i*math.rad(30)), cy - radius*math.cos(i*math.rad(30)) )
	cr:stroke ()

  end

  -- Рисуем минутные деления
  cr:set_line_width (1)
  cr:set_source_rgba (0.7, 0.7, 0.7, 1)

  for i = 0,59 do

        cr:move_to (cx + (radius - min_len)*math.sin(i*math.rad(6)), cy - (radius - min_len)*math.cos(i*math.rad(6)) )
        cr:line_to (cx + radius*math.sin(i*math.rad(6)), cy - radius*math.cos(i*math.rad(6)) )
        cr:stroke ()

  end

  -- Рисуем цифры на циферблате
  local dig_size = 15
  local dig_radius = radius/1.3
  local n_hours = 12

  local extents

  cr:select_font_face ('Times', 0, 0)
  cr:set_font_size (dig_size)

  for i = 1,n_hours do

	local dig = i*12/n_hours
	extents = cr:text_extents (dig)
	
	local dx = cx + dig_radius*math.sin(i*math.rad(360/n_hours))
	local dy = cy - dig_radius*math.cos(i*math.rad(360/n_hours))

	local tx = dx - extents.width/2
	local ty = dy + extents.height/2

	cr:move_to (tx, ty)
	cr:show_text(dig)

  end

  -- Рисуем стрелки

  -- Получаем текущее время
  local sec = os.date('%S')
  local min = os.date('%M')
  local hour = os.date('%H')

  -- Задаем длины стрелок
  local hour_arrow_len = radius/1.8
  local min_arrow_len = radius - min_len - 8
  local sec_arrow_len = radius - min_len - 6

  -- Отрисовываем часовую стрелку
  cr:set_line_width (4)
  cr:set_source_rgba (1, 1, 1, 1)

  cr:move_to (cx, cy)
  cr:line_to (cx + hour_arrow_len*math.sin(math.rad((hour + min/60 + sec/3600)*30)), cy - hour_arrow_len*math.cos(math.rad((hour + min/60 + sec/3600)*30)) )
  cr:stroke ()

  -- Отрисовываем минутную стрелку
  cr:set_line_width (2)
  cr:set_source_rgba (1, 1, 1, 1)

  cr:move_to (cx, cy)
  cr:line_to (cx + min_arrow_len*math.sin(math.rad((min + sec/60)*6)), cy - sec_arrow_len*math.cos(math.rad((min + sec/60)*6)) )
  cr:stroke ()

  -- Отрисовываем секундную стрелку
  cr:set_line_width (2)
  cr:set_source_rgba (1, 0.5, 0, 1)

  cr:move_to (cx, cy)
  cr:line_to (cx + sec_arrow_len*math.sin(sec*math.rad(6)), cy - sec_arrow_len*math.cos(sec*math.rad(6)) )
  cr:stroke ()   

end

-------------------------------------------------------------------------------
--	Размещаем виджет
-------------------------------------------------------------------------------
local clock_layout = wibox.layout.fixed.horizontal()

clock_layout:add(clock_widget)

clock_wbox:set_widget(clock_layout)

-------------------------------------------------------------------------------
--	Анимация
-------------------------------------------------------------------------------

-- Делаем таймер с интервалом в 100 мс
local timer = capi.timer{timeout = 0.1}

-- Вешаем на таймер отрисовку wibox
timer:connect_signal("timeout", function() clock_wbox.draw() end)

-- Запускаем таймер
timer:start()

-- Заставляем таймер генерировать сигнал timeout
timer:emit_signal("timeout")


clock.clock_wbox = clock_wbox

-- Возвращаем часы наружу из модуля
return clock