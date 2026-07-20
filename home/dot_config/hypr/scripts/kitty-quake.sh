#!/usr/bin/env bash
# Сохраняем один kitty; специальный workspace нужен только для скрытия окна.
set -euo pipefail

exec 9>"${XDG_RUNTIME_DIR:?}/kitty-quake.lock"
flock -n 9 || exit 0

client() {
    hyprctl -j clients | jq -c 'first(.[] | select(.class == "kitty-quake")) // empty'
}

window=$(client)
if [[ -z $window ]]; then
    hyprctl dispatch exec 'kitty --class kitty-quake --title Quake' >/dev/null
    for ((i = 0; i < 100; i++)); do
        window=$(client)
        [[ -n $window ]] && break
        sleep 0.05
    done
    if [[ -z $window ]]; then
        notify-send 'Quake-терминал' 'kitty не открылся за 5 секунд.'
        exit 1
    fi
fi

address=$(jq -r '.address' <<<"$window")
monitor=$(hyprctl -j monitors | jq -c 'first(.[] | select(.focused))')
workspace=$(jq -r '.activeWorkspace.id' <<<"$monitor")
window_workspace=$(jq -r '.workspace.id' <<<"$window")
slide_script="$(dirname -- "${BASH_SOURCE[0]}")/kitty-quake-slide.py"

if [[ $window_workspace == "$workspace" ]]; then
    read -r x y height < <(jq -r '[.at[0], .at[1], .size[1]] | @tsv' <<<"$window")
    hidden_y=$(jq -r --argjson height "$height" '.y - $height - 20' <<<"$monitor")
    # Сначала уводим окно за верхний край, затем прячем без завершения задач.
    python3 "$slide_script" "$address" "$x" "$y" "$hidden_y" hide
    hyprctl dispatch movetoworkspacesilent "special:quake,address:$address" >/dev/null
    exit 0
fi

# Размер и положение в логических пикселях: учитываем масштаб, поворот и панель.
read -r x y width height < <(jq -r '
    ((if (.transform % 2) == 1 then .height else .width end) / .scale | floor) as $w |
    ((if (.transform % 2) == 1 then .width else .height end) / .scale | floor) as $h |
    [(.x + .reserved[0] + 2),
     (.y + .reserved[1] + 2),
     ($w - .reserved[0] - .reserved[2] - 4),
     (($h - .reserved[1] - .reserved[3]) / 2 | floor) - 4] | @tsv
' <<<"$monitor")

hidden_y=$(jq -r --argjson height "$height" '.y - $height - 20' <<<"$monitor")
# Подготавливаем скрытое окно за верхним краем, чтобы оно не мелькнуло при показе.
hyprctl --batch "dispatch resizewindowpixel exact $width $height,address:$address; dispatch movewindowpixel exact $x $hidden_y,address:$address; dispatch movetoworkspacesilent $workspace,address:$address; dispatch movewindowpixel exact $x $hidden_y,address:$address; dispatch alterzorder top,address:$address" >/dev/null
python3 "$slide_script" "$address" "$x" "$hidden_y" "$y" show
hyprctl dispatch focuswindow "address:$address" >/dev/null
