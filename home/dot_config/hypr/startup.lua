-- Эти команды выполняются один раз при входе в Hyprland, не при reload

return function(config)
    hl.on("hyprland.start", function()
        -- Восстановление обоев, индикатор сети и пользовательское управление вентиляторами NVIDIA
        hl.exec_cmd("waypaper --restore")
        hl.exec_cmd("nm-applet --indicator")
        hl.exec_cmd("nvidiafan.sh")

        -- Передать Wayland-дисплей и имя окружения в D-Bus и пользовательский systemd
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

        -- История буфера обмена: отдельные наблюдатели для текста и изображений
        hl.exec_cmd("wl-paste --type text --watch cliphist store")
        hl.exec_cmd("wl-paste --type image --watch cliphist store")

        -- Стартовые приложения: silent не переключает фокус на их стол, no_anim убирает анимацию
        hl.exec_cmd("firefox", { workspace = "1 silent", no_anim = true })
        hl.exec_cmd(config.terminal, { workspace = "2 silent", no_anim = true })
        hl.exec_cmd("code", { workspace = "3 silent", no_anim = true })

        -- Панель\оболочка
        hl.exec_cmd("auto_ags")

        -- Столы 1–7 создаются правилами persistent в workspaces.lua; при входе выбираем первый
        hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    end)
end
