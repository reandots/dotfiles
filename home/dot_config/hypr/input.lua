-- See https://wiki.hypr.land/configuring/core/config-options/#input
hl.config({
    input = {
        kb_layout = "us,ru",
        kb_variant = ",winkeys",
        kb_model = "",
        kb_options = "grp:caps_toggle",
        kb_rules = "",
        repeat_rate = 25,  -- Повторов в секунду
        repeat_delay = 600, -- Задержка перед повтором, мс
        sensitivity = 0,
        -- Фокус меняется явно, а не при движении указателя
        follow_mouse = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.device({ name = "logitech-usb-receiver-mouse", natural_scroll = false })
