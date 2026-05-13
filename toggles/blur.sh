#!/bin/bash
# Toggle Hyprland blur effects

STATE_FILE="/tmp/quasar-toggle-blur"

if [[ -f "$STATE_FILE" ]]; then
    hyprctl eval 'hl.config({ decoration = { blur = { enabled = false } } })'
    rm -f "$STATE_FILE"
    msg2 "Blur disabled."
else
    hyprctl eval 'hl.config({ decoration = { blur = { enabled = true } } })'
    touch "$STATE_FILE"
    msg2 "Blur enabled."
fi
