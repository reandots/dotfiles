hl.config({
    -- https://wiki.hypr.land/configuring/core/config-options/#general
    general = {
        -- Толщина рамки окна, в логических пикселях
        border_size = 2,
        -- Внутренние отступы между плиточными окнами, в логических пикселях
        gaps_in = 4,
        -- Отступы от краёв экрана: сверху, справа, снизу, слева
        gaps_out = { top = 5, right = 0, bottom = 0, left = 0 },
        -- Дополнительный зазор между рабочими столами при анимации переключения
        gaps_workspaces = 0,
        col = {
            -- Рамка неактивного окна: серый цвет с прозрачностью (формат RRGGBBAA)
            inactive_border = "rgba(595959aa)",
            -- Рамка активного окна: градиент от голубого к зелёному под углом 45°
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
                angle = 45,
            },
        },
        -- false - не менять размер окна перетаскиванием его рамки или зазора
        resize_on_border = false,
        -- false - запретить tearing (разрывы изображения ради меньшей задержки)
        allow_tearing = false,
    },
    -- https://wiki.hypr.land/configuring/core/config-options/#decoration
    decoration = {
        rounding = 7,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        blur = { enabled = true, size = 3, passes = 1, vibrancy = 0.1696 },
    },
    -- https://wiki.hypr.land/configuring/core/animations/
    animations = { enabled = true },
    -- https://wiki.hypr.land/configuring/core/config-options/#misc
    misc = {
        focus_on_activate = true,
        force_default_wallpaper = -1,
        -- false - показывать логотип Hyprland на встроенном фоне; true - скрывать
        disable_hyprland_logo = false,
        -- Alt+Tab (cycle_next) сохраняет fullscreen при переключении окон
        on_focus_under_fullscreen = 1,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
