#!/usr/bin/env bash

lightdark="dark"
transparency="opaque"
materialscheme="vibrant"
imagepath="/usr/share/hyprland/wall2.png"
terminalscheme="/home/rean/projects/home/dotfiles/.config/hypr/scripts/scheme-base.json"

# smartflag=''
smartflag='--smart'

./generate_colors_material.py --path "$imagepath" \
--mode "$lightdark" --scheme "$materialscheme" --transparency "$transparency" \
--termscheme $terminalscheme --blend_bg_fg \
--cache "/home/rean/projects/home/dotfiles/.config/hypr/scripts/color.txt" $smartflag \
> "/home/rean/projects/home/dotfiles/.config/hypr/scripts/material_colors.scss"
