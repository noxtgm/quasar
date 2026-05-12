#!/bin/bash

_backup_file() {
    local file="$1"
    if [[ -f "$file" && ! -L "$file" ]]; then
        cp "$file" "${file}.bak" && msg2 "Backed up $file."
    fi
}

_add_line_if_missing() {
    local file="$1"
    local line="$2"

    [[ -f "$file" ]] || touch "$file"
    grep -qxF "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}

autostart_hyprland() {
    local bash_profile="$HOME/.bash_profile"
    local line='[[ -z "$DISPLAY" && "$XDG_VTNR" == "1" ]] && exec Hyprland'

    _backup_file "$bash_profile"

    if _add_line_if_missing "$bash_profile" "$line"; then
        msg "Configured Hyprland auto-start."
    else
        return 1
    fi
}

configure_shell() {
    local bashrc="$HOME/.bashrc"
    local start_marker="# --- ${REPO_NAME} shell ---"
    local end_marker="# --- end ${REPO_NAME} shell ---"

    _backup_file "$bashrc"
    [[ -f "$bashrc" ]] || touch "$bashrc"

    if grep -qF "$start_marker" "$bashrc" 2>/dev/null; then
        sed -i "/$start_marker/,/$end_marker/d" "$bashrc"
    fi

    {
        echo "$start_marker"
        echo "[[ -f \"${REPO_SHELL}/init.sh\" ]] && source \"${REPO_SHELL}/init.sh\""
        echo "$end_marker"
    } >> "$bashrc"

    msg "Configured shell."
}
