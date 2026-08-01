#!/usr/bin/env python3
"""Плавное перемещение только быстрого терминала через сокет Hyprland."""

import os
from pathlib import Path
import socket
import sys
import time


def dispatch(lua):
    path = Path(os.environ["XDG_RUNTIME_DIR"]) / "hypr" / os.environ["HYPRLAND_INSTANCE_SIGNATURE"] / ".socket.sock"
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
        connection.settimeout(2)
        connection.connect(str(path))
        connection.sendall(f"dispatch {lua}".encode())
        response = connection.recv(4096).decode().strip()
        if response != "ok":
            raise RuntimeError(response)


def slide(address, x, start_y, end_y, showing):
    duration = 0.24
    started = time.monotonic()
    frame = 0
    while True:
        progress = min((time.monotonic() - started) / duration, 1)
        # При показе замедляемся к концу, при скрытии плавно набираем скорость.
        eased = 1 - (1 - progress) ** 3 if showing else progress ** 3
        y = round(start_y + (end_y - start_y) * eased)
        dispatch(f"hl.dsp.window.move({{ x = {x}, y = {y}, window = 'address:{address}' }})")
        if progress == 1:
            break
        frame += 1
        time.sleep(max(0, started + frame / 60 - time.monotonic()))


if __name__ == "__main__":
    address, x, start_y, end_y, direction = sys.argv[1:]
    slide(address, int(x), int(start_y), int(end_y), direction == "show")
