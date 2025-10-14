#!/usr/bin/env bash

# cmd='rofi -i -dmenu -p "2FA Codes"'
cmd='tofi --prompt-text="2FA Codes"'

selected=$(ykman oath accounts list | eval "$cmd")

if [ -n "$selected" ]; then
    code=$(ykman oath accounts code --single "$selected")
    echo "$code" | wl-copy
    notify-send "Code for $selected copied to clipboard: $code"
fi
