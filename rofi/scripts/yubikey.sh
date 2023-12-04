#!/usr/bin/env bash

# cmd='rofi -i -dmenu -p "2FA Codes"'
cmd='tofi --prompt-text="2FA Codes"'

selected=$(ykman oath accounts list | eval $cmd)

if [ -n "$selected" ]; then
    ykman oath accounts code --single $selected | wl-copy
    notify-send "Code for $selected copied to clipboard"
fi
