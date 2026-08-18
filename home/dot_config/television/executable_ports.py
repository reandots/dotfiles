#!/usr/bin/env python3
"""TCP listener rows, details, and identity-checked process signals for tv."""

import os
import re
import pwd
import sys
import shlex
import signal
import textwrap
import subprocess
from typing import Any, Generator, LiteralString
from pathlib import Path


def clean(text) -> LiteralString:
    return "".join(c if c.isprintable() and c != "|" else "?" for c in text)


def start_time(pid) -> str:
    # comm can contain spaces and parentheses; fields after its final ')' are fixed.
    return Path(f"/proc/{pid}/stat").read_text().rsplit(")", 1)[1].split()[19]


def listeners() -> Generator[dict[str, str | Any], Any, None]:
    result = subprocess.run(["ss", "-H", "-ltnpe"], check=True, capture_output=True, text=True)
    for line in result.stdout.splitlines():
        fields = line.split()
        inode = re.search(r"\bino:(\d+)", line)
        if len(fields) < 5 or inode is None:
            continue
        uid = re.search(r"\buid:(\d+)", line)
        owners = list(dict.fromkeys(re.findall(r'\("(.*?)",pid=(\d+),fd=\d+', line)))
        yield dict(
            inode=inode[1],
            endpoint=fields[3],
            queue=fields[1],
            backlog=fields[2],
            uid=int(uid[1]) if uid else 0,
            owners=owners,
            raw=line,
        )


def list_rows() -> None:
    rows = []
    for item in listeners():
        address, port = item["endpoint"].rsplit(":", 1)
        if address == "*" and "v6only:" in item["raw"]:
            address = "[::]"
        for name, pid in item["owners"] or [("unavailable", "0")]:
            try:
                born = start_time(pid) if pid != "0" else "0"
            except FileNotFoundError:
                continue  # Process exited during enumeration.
            label = f"{port:<5}  {address:<20}  {clean(name):<12}  PID {pid if pid != '0' else '?'}"
            rows.append((int(port), item["endpoint"], int(pid), f"{item['inode']}|{pid}|{born}|{label}"))
    for _, _, _, row in sorted(rows):
        print(row)


def selected(inode, pid, born) -> dict[str, str | Any]:
    item = next((item for item in listeners() if item["inode"] == inode), None)
    if item is None:
        raise ValueError("Listener no longer exists. Reload with Ctrl-R.")
    if pid != "0":
        if not any(owner_pid == pid for _, owner_pid in item["owners"]):
            raise ValueError("Process no longer owns this listener. Reload with Ctrl-R.")
        if start_time(pid) != born:
            raise ValueError("Process identity changed. Reload with Ctrl-R.")
    return item


def details(item, pid) -> None:
    try:
        user = pwd.getpwuid(item["uid"]).pw_name
    except KeyError:
        user = str(item["uid"])
    print(f"TCP LISTEN\nAddress: {item['endpoint']}\nSocket inode: {item['inode']}")
    print(f"User: {clean(user)} (UID {item['uid']})")
    print(f"Pending connections: {item['queue']}\nBacklog limit: {item['backlog']}")
    if pid == "0":
        print("Process / PID: unavailable (ss did not expose an owner).")
        print("Signals are disabled for this row.")
    else:
        print(f"PID: {pid}")
        args = Path(f"/proc/{pid}/cmdline").read_bytes().split(b"\0")
        command = shlex.join(arg.decode(errors="replace") for arg in args if arg)
        print(textwrap.fill(f"Command: {clean(command) or 'unavailable'}", width=50, subsequent_indent="  "))
    print("\nSocket details:\n" + textwrap.fill(clean(item["raw"]), width=50))


def send_signal(inode, pid, born, kind) -> None:
    if pid == "0":
        raise ValueError("No visible PID for this listener; no signal sent.")
    sig = {"term": signal.SIGTERM, "kill": signal.SIGKILL}[kind]
    # Pin the process before checking /proc, including across the confirmation wait.
    fd = os.pidfd_open(int(pid))
    try:
        item = selected(inode, pid, born)
        details(item, pid)
        try:
            reply = input(f"\nSend {sig.name} to PID {pid} at {item['endpoint']}? [y/N] ")
        except EOFError:
            reply = ""
        if reply not in ("y", "Y", "yes", "YES"):
            print("Cancelled; no signal sent.")
            return
        selected(inode, pid, born)
        signal.pidfd_send_signal(fd, sig)
        print(f"{sig.name} sent to PID {pid}.")
    finally:
        os.close(fd)


def main() -> None:
    if sys.argv[1:] == ["list"]:
        list_rows()
        return
    mode, inode, pid, born = sys.argv[1:]
    if not all(value.isdecimal() for value in (inode, pid, born)):
        raise ValueError("Invalid listener identity.")
    if mode == "info":
        details(selected(inode, pid, born), pid)
    elif mode in ("term", "kill"):
        send_signal(inode, pid, born, mode)
    else:
        raise ValueError("Unknown action.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"ports: {error}", file=sys.stderr)
        sys.exit(1)
