#!/bin/bash

# Проверка наличия хотя бы одного аргумента
if [ $# -lt 2 ]; then
  echo "Usage: $0 WORKSPACE COMMAND [ARGS...]"
  exit 1
fi

WORKSPACE=$1
hyprctl dispatch workspace "$WORKSPACE"

shift
"$@"
