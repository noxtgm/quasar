#!/bin/bash
# Toggle Hyprland blur effects

current=$(hyprctl getoption decoration:blur:enabled -j 2>/dev/null | sed -n 's/.*"int": \([0-9]*\).*/\1/p')

if [[ "$current" -eq 1 ]] 2>/dev/null; then
    hyprctl keyword decoration:blur:enabled false
    msg2 "Blur disabled."
else
    hyprctl keyword decoration:blur:enabled true
    msg2 "Blur enabled."
fi
