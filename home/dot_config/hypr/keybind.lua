-- See https://wiki.hypr.land/configuring/core/binds/
-- See https://wiki.hypr.land/configuring/core/

return function(config)
    -- Основной модификатор - клавиша Win/Super
    local mainMod = "SUPER"
    -- Пользовательская команда снимков экрана
    local screenshot = "screenshot"
    local terminal = config.terminal
    local scripts = config.scripts

    -- Сессия: Win+Ctrl+Shift+Q - выйти из Hyprland; Win+Backspace - заблокировать экран
    hl.bind(mainMod .. " + SHIFT + CTRL + Q", hl.dsp.exit())
    hl.bind(mainMod .. " + BACKSPACE", hl.dsp.exec_cmd("hyprlock"))

    -- Рабочие столы
    for i = 1, 10 do
        local key = i % 10
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        -- Win+Shift+цифра - перенести окно на указанный стол и перейти вслед за ним
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
    hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ workspace = "-1" }))
    hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ workspace = "+1" }))
    hl.bind(mainMod .. " + UP", hl.dsp.focus({ workspace = "+1" }))
    hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ workspace = "-1" }))

    -- Фокус окна: Win+J/L - влево/вправо, Win+I/K - вверх/вниз
    hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + I", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "down" }))
    -- Win+Tab - текущее/предыдущее окно; Alt+Tab и Alt+Shift+Tab - обход вперёд/назад
    hl.bind(mainMod .. " + TAB", hl.dsp.focus({ last = true }))
    hl.bind("ALT + TAB", hl.dsp.window.cycle_next())
    hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))

    -- Win+Shift+J/L/I/K - поменять окно местами с соседом в указанном направлении
    hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "left" }))
    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
    hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.swap({ direction = "up" }))
    hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "down" }))

    local function resize_percent(x_factor, y_factor)
        return function()
            local window = hl.get_active_window()
            if not window then return end
            hl.dispatch(hl.dsp.window.resize({
                x = math.floor(window.size.x * x_factor),
                y = math.floor(window.size.y * y_factor),
            }))
        end
    end
    -- Win+Ctrl+J/L/I/K - уменьшить/увеличить ширину или высоту окна шагом 5%
    hl.bind(mainMod .. " + CTRL + J", resize_percent(0.95, 1))
    hl.bind(mainMod .. " + CTRL + L", resize_percent(1.05, 1))
    hl.bind(mainMod .. " + CTRL + I", resize_percent(1, 0.95))
    hl.bind(mainMod .. " + CTRL + K", resize_percent(1, 1.05))
    -- Win+левая кнопка мыши - перемещение окна; Win+правая - изменение размера
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Win+F - полный экран; Win+M - максимизация с учётом панелей и отступов
    hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
    -- Win+B - переключить плавающий режим; Win+Shift+Q - закрыть активное окно
    hl.bind(mainMod .. " + B", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())

    -- Терминалы: Win+Enter - Kitty; Win+Shift+Enter - Kitty+Herdr; Win + ~ - quake Kitty
    hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
    hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("kitty --config ~/.config/kitty/herdr.conf herdr"))
    hl.bind(mainMod .. " + code:49", hl.dsp.exec_cmd('bash "' .. scripts .. '/kitty-quake.sh"'))
    -- Runix: Win+R и Win+Shift+R
    hl.bind(mainMod .. " + R", hl.dsp.exec_cmd('"$HOME/projects/runix/runix/runix_release"'))
    hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd('"$HOME/projects/runix/runix/runix" -d'))

    -- Снимки экрана: Win+S включает отдельный режим; затем Q - область, W - окно, E - экран
    -- После выбора возвращаемся к обычным биндам; Escape отменяет выбор режима
    hl.bind(mainMod .. " + S", hl.dsp.submap(screenshot))
    hl.define_submap(screenshot, "reset", function()
        hl.bind("Q", hl.dsp.exec_cmd('notify-send "Screenshot area" & ' .. screenshot .. " --area"))
        hl.bind("W", hl.dsp.exec_cmd('notify-send "Screenshot window" & ' .. screenshot .. " --window"))
        hl.bind("E", hl.dsp.exec_cmd('notify-send "Screenshot screen" & ' .. screenshot .. " --screen"))
        hl.bind("ESCAPE", hl.dsp.submap("reset"))
    end)

    -- Буфер обмена: Win+V - выбрать запись из истории и скопировать её в текущий буфер
    hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
    -- Win+Shift+V - стереть всю историю cliphist без подтверждения
    hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist wipe"))
end
