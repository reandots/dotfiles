-- See https://wiki.hypr.land/configuring/core/environment-variables/
-- See https://wiki.hypr.land/hypr-ecosystem/user/hyprcursor/
-- Курсоры: XCURSOR для X11/XWayland и клиентов без поддержки hyprcursor
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "rose-pine-cursor")
-- Тема и размер для клиентов с поддержкой hyprcursor
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

-- GTK и Clutter: Wayland, для GTK сохранён запасной вариант X11
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11")

-- Qt 5: автоматическое масштабирование по параметрам экрана
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
-- Qt: предпочитать Wayland, при недоступности плагина использовать xcb (X11)
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- Оформление Qt 5 через плагин qt5ct
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- Дополнительный множитель масштаба для Qt-приложений вроде Double Commander
hl.env("QT_SCALE_FACTOR", "1.25")
-- Отключить клиентские декорации окон Qt Wayland
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- SDL: только Wayland, без запасного варианта X11
hl.env("SDL_VIDEODRIVER", "wayland")

-- Совместимость с Electron до 38: автоматически выбирать Wayland/X11
-- В Electron 38+ переменная удалена; сохранена для приложений со старым Electron
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Идентификация сессии для приложений и служб рабочего стола
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- NVIDIA: выбор VA-API драйвера для аппаратного декодирования видео
hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- GLX для X11/XWayland: использовать реализацию NVIDIA
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- Backend nvidia-vaapi-driver: прямой доступ к драйверу NVIDIA вместо EGL
hl.env("NVD_BACKEND", "direct")

-- Не растягивать XWayland-окна композитором при дробном масштабе монитора
-- Масштаб интерфейса тогда настраивается на стороне X11-приложений
hl.config({ xwayland = { force_zero_scaling = true } })
