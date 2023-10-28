#!/usr/bin/env bash

selected=$(ykman oath accounts list | rofi -i -dmenu -p "2FA Codes")

if [ -n "$selected" ]; then
    ykman oath accounts code --single $selected | wl-copy
    notify-send "Code for $selected copied to clipboard"
fi
