-- See https://wiki.hypr.land/configuring/core/rules/window-rules/

-- Приложения не максимизируются по собственному запросу; ручное управление остаётся
hl.window_rule({ name = "ignore-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- Отдельные окна приложений: звук и выбор обоев - плавающие, Meld - максимизирован
-- match.class - регулярное выражение; ^ и $ требуют совпадения всего класса
hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = [[^(org\.gnome\.Meld)$]] }, maximize = true })
hl.window_rule({ match = { class = "^(waypaper)$" }, float = true })

-- Новые окна VS Code направлять на рабочий стол разработки
hl.window_rule({ match = { class = "^(code)$" }, workspace = "3" })

-- Плавающие диалоги: одновременно должны совпасть класс приложения и заголовок
hl.window_rule({ match = { class = "^(code)$", title = "^(Save As|Open File|Open Folder|Open)$" }, float = true })
hl.window_rule({ match = { class = "^(doublecmd)$", title = "^(Поиск файлов|~/.*|/.*)$" }, float = true })
hl.window_rule({ match = { class = "^(terminator)$", title = "^(Терминатор Параметры|Настройки)$" }, float = true })

-- Сетевые настройки и вспомогательные интерфейсы открывать плавающими
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = "^(runify-ui)$" }, float = true })
hl.window_rule({ match = { class = "^(VoiceAssistant)$" }, float = true })

-- Runix: плавающее окно размером не меньше 800 × 600 логических пикселей
hl.window_rule({ match = { class = "^(Runix)$" }, min_size = { 800, 600 } })
hl.window_rule({ match = { class = "^(Runix)$" }, float = true })

-- Quake-терминал запускается скрытым; скрипт переносит его на текущий workspace
hl.window_rule({ match = { class = "^(kitty-quake)$" }, float = true })
hl.window_rule({ match = { class = "^(kitty-quake)$" }, workspace = "special:quake silent" })
-- Движением управляет скрипт; штатная анимация не должна накладываться поверх
hl.window_rule({ match = { class = "^(kitty-quake)$" }, no_anim = true })
