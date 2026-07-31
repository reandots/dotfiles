-- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
hl.config({
    -- Dwindle: новые плиточные окна делят область одного из существующих окон
    -- Здесь выбирается раскладка; блок dwindle ниже задаёт её параметры
    general = { layout = "dwindle" },
    -- Сохранять направление разбиения при изменении дерева окон
    dwindle = { preserve_split = true },
})
