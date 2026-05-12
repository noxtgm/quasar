#!/bin/bash
# Toggle Hyprland window gaps

GAPS_OUT_DEFAULT=10
GAPS_IN_DEFAULT=5
STATE_FILE="/tmp/quasar-toggle-gaps"

if [[ -f "$STATE_FILE" ]]; then
    hyprctl eval "hl.config({ general = { gaps_out = $GAPS_OUT_DEFAULT, gaps_in = $GAPS_IN_DEFAULT } })"
    rm -f "$STATE_FILE"
    msg2 "Gaps enabled."
else
    hyprctl eval 'hl.config({ general = { gaps_out = 0, gaps_in = 0 } })'
    touch "$STATE_FILE"
    msg2 "Gaps disabled."
fi
