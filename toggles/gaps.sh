#!/bin/bash
# Toggle Hyprland window gaps

GAPS_OUT_DEFAULT=8
GAPS_IN_DEFAULT=4

current=$(hyprctl getoption general:gaps_out -j 2>/dev/null | sed -n 's/.*"custom": "\([0-9]*\).*/\1/p')

if [[ "$current" -gt 0 ]] 2>/dev/null; then
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:gaps_in 0
    msg2 "Gaps disabled."
else
    hyprctl keyword general:gaps_out "$GAPS_OUT_DEFAULT"
    hyprctl keyword general:gaps_in "$GAPS_IN_DEFAULT"
    msg2 "Gaps enabled."
fi
