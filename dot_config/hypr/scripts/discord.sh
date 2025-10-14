#!/usr/bin/env bash
# Usage: discord.sh [mute|deaf] [client]
# Workaround for discord keybinds on hyprland
# saves the active window, moves focus to discord, and sends the keybind, then moves back to the original window

addr=$(hyprctl activewindow -j | jq -r '.address // ""')
command=$1
client=${2:-"discord"} # default to discord, but I use vesktop
pos=$(hyprctl cursorpos | tr -d ',')

if [ -z "$addr" ]; then
    workspace=$(hyprctl activeworkspace -j | jq -r ".name")
fi

hyprctl dispatch focuswindow $client

case $command in
    "mute")
        hyprctl dispatch sendshortcut "CTRL + SHIFT, M, ^$client\$"
        ;;
    "deaf")
        hyprctl dispatch sendshortcut "CTRL + SHIFT, D, ^$client\$"
        ;;
esac

if [ -n "$workspace" ]; then
    hyprctl dispatch workspace $workspace
else
    hyprctl dispatch focuswindow address:$addr
fi

hyprctl dispatch movecursor $pos
